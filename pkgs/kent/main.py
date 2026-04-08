import os
import sys
import shutil
import tomllib
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime, format_datetime
from pathlib import Path
from urllib.parse import urlparse
import requests
from rich.progress import (
    BarColumn,
    DownloadColumn,
    Progress,
    TaskProgressColumn,
    TextColumn,
    TimeRemainingColumn,
    TransferSpeedColumn,
)

CONNECT_TIMEOUT = 10
READ_TIMEOUT = 60
USER_AGENT = "kent/1.0"


def resolve_project_path(root, path_value):
    """Resolve config paths relative to the project root."""
    path = Path(path_value)
    if path.is_absolute():
        return path
    return root / path


def log(message, level="INFO"):
    print(f"[{level}] {message}")


def log_error(message):
    print(f"[ERROR] {message}", file=sys.stderr)


def validate_url(url):
    parsed = urlparse(url)
    return parsed.scheme in {"http", "https"} and bool(parsed.netloc)


def parse_remote_datetime(header_value):
    if not header_value:
        return datetime(1970, 1, 1, tzinfo=timezone.utc)
    try:
        parsed = parsedate_to_datetime(header_value)
        return parsed if parsed.tzinfo else parsed.replace(tzinfo=timezone.utc)
    except Exception:
        return datetime(1970, 1, 1, tzinfo=timezone.utc)


def fetch_remote_timestamp(url):
    headers = {"User-Agent": USER_AGENT}
    timeout = (CONNECT_TIMEOUT, READ_TIMEOUT)

    try:
        response = requests.head(url, headers=headers,
                                 allow_redirects=True, timeout=timeout)
        response.raise_for_status()
        header_value = response.headers.get(
            "Last-Modified") or response.headers.get("Date")
        return parse_remote_datetime(header_value), header_value
    except requests.RequestException:
        pass

    try:
        with requests.get(
                url,
                headers=headers,
                stream=True,
                allow_redirects=True,
                timeout=timeout
        ) as response:
            response.raise_for_status()
            header_value = response.headers.get(
                "Last-Modified") or response.headers.get("Date")
            return parse_remote_datetime(header_value), header_value
    except requests.RequestException as exc:
        log_error(f"Could not fetch remote metadata: {exc}")
        return None, None


def remove_partial_download(partial_path):
    """Delete a stale partial download file."""
    try:
        os.remove(partial_path)
        return True
    except FileNotFoundError:
        return True
    except OSError as exc:
        log_error(f"Could not remove partial download {partial_path}: {exc}")
        return False


def archive_replaced_file(current_file, archive_dir, timestamp):
    """Move the replaced file into the archive directory when possible."""
    archive_name = archive_dir / f"{timestamp} - {current_file.name}"
    try:
        shutil.move(str(current_file), str(archive_name))
        log(f"Saved previous version as: {archive_name.name}")
        return archive_name
    except OSError as exc:
        log(
            f"Could not archive previous version to {archive_dir}; "
            f"keeping backup at {current_file.name} ({exc})",
            level="WARN",
        )
        return None


def main():
    project_root = Path.cwd()
    config_path = project_root / "update.toml"
    ownership_ref = config_path if config_path.exists() else project_root

    with config_path.open("rb") as f:
        cfg = tomllib.load(f)
    url = cfg["url"]
    pdf_file = resolve_project_path(project_root, cfg["pdf_file"])
    archive_dir = resolve_project_path(project_root, cfg["archive_dir"])

    if not validate_url(url):
        log_error(f"Unsupported URL: {url}")
        return

    archive_dir.mkdir(parents=True, exist_ok=True)

    if not pdf_file.exists():
        log(f"{pdf_file.name} not found, downloading...")
        downloaded_file = download_file(url, pdf_file, ownership_ref)
        if downloaded_file is None:
            log_error(f"Download did not complete for {pdf_file.name}")
        return

    local_mtime_utc = datetime.fromtimestamp(
        pdf_file.stat().st_mtime, tz=timezone.utc
    )

    remote_lastmod, remote_lastmod_str = fetch_remote_timestamp(url)
    if remote_lastmod is None:
        log(
            f"Keeping existing file {pdf_file.name}; "
            "remote metadata unavailable.",
            level="WARN",
        )
        return

    if remote_lastmod > local_mtime_utc:
        log(f"Remote version newer ({remote_lastmod_str}); updating...")
        staged_file = download_file(
            url,
            pdf_file,
            ownership_ref,
            preserve_existing=True,
        )
        if staged_file is None:
            log(
                f"Keeping existing file {pdf_file.name}; "
                "replacement download did not complete.",
                level="WARN",
            )
            return

        timestamp = local_mtime_utc.astimezone().strftime("%Y-%m-%d_%H-%M-%S")
        backup_file = pdf_file.with_name(f"{pdf_file.name}.previous")
        os.replace(pdf_file, backup_file)
        os.replace(staged_file, pdf_file)
        os.utime(
            pdf_file,
            (remote_lastmod.timestamp(), remote_lastmod.timestamp()),
        )
        archive_replaced_file(backup_file, archive_dir, timestamp)
        log(f"Updated {pdf_file.name} with timestamp {remote_lastmod_str}")
    else:
        local_display = local_mtime_utc.astimezone()
        log(
            f"{pdf_file.name} is up to date "
            f"({format_datetime(local_display)})."
        )


def download_file(url, dest, ownership_ref, preserve_existing=False):
    """Download to a partial file and return the completed file path."""
    dest = Path(dest)
    ownership_ref = Path(ownership_ref)
    partial = dest.with_name(f"{dest.name}.part")
    final_target = partial if preserve_existing else dest
    timeout = (CONNECT_TIMEOUT, READ_TIMEOUT)
    request_headers = {"User-Agent": USER_AGENT}
    resumed_bytes = 0

    if partial.exists():
        if dest.exists() and dest.stat().st_mtime > partial.stat().st_mtime:
            log(
                f"Discarding stale partial download for {dest.name}.",
                level="WARN",
            )
            if not remove_partial_download(partial):
                return None
        else:
            resumed_bytes = partial.stat().st_size

    if resumed_bytes:
        request_headers["Range"] = f"bytes={resumed_bytes}-"

    try:
        with requests.get(
            url,
            headers=request_headers,
            stream=True,
            allow_redirects=True,
            timeout=timeout,
        ) as resp:
            resp.raise_for_status()
            if resumed_bytes and resp.status_code != 206:
                log(
                    f"Server did not honor resume for {dest.name}; "
                    "restarting download.",
                    level="WARN",
                )
                if not remove_partial_download(partial):
                    return None
                return download_file(
                    url,
                    dest,
                    ownership_ref,
                    preserve_existing,
                )

            total = int(resp.headers.get("Content-Length") or 0)
            if resp.status_code == 206:
                total += resumed_bytes

            chunk_size = 8192
            mode = "ab" if resumed_bytes else "wb"
            progress = Progress(
                TextColumn("{task.fields[filename]:<20}", justify="left"),
                TaskProgressColumn(),
                BarColumn(bar_width=None),
                DownloadColumn(),
                TransferSpeedColumn(),
                TimeRemainingColumn(),
            )
            with partial.open(mode) as f, progress:
                task_id = progress.add_task(
                    "download",
                    filename=dest.name,
                    total=total or None,
                    completed=resumed_bytes,
                )
                for chunk in resp.iter_content(chunk_size=chunk_size):
                    if not chunk:
                        continue
                    f.write(chunk)
                    progress.update(task_id, advance=len(chunk))
        if total and partial.stat().st_size != total:
            raise RuntimeError(
                "Incomplete download: expected "
                f"{total} bytes, got {partial.stat().st_size}"
            )
        finalize_ownership(partial, ownership_ref)
        if not preserve_existing:
            os.replace(partial, final_target)
        return final_target
    except (requests.RequestException, OSError, RuntimeError) as exc:
        log_error(f"Download failed for {dest.name}: {exc}")
        return None


def finalize_ownership(file_path, ref_path):
    """Ensure file_path has the same owner/group as ref_path."""
    try:
        st = os.stat(ref_path)
        os.chown(file_path, st.st_uid, st.st_gid)
    except PermissionError:
        print(
            "Warning: insufficient permissions to change "
            f"ownership of {file_path}"
        )
    except AttributeError:
        pass


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        log_error(f"Unhandled error: {exc}")
