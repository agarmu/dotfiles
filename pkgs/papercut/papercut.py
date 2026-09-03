#!/usr/bin/env python3

import signal
import socket
import subprocess
import sys
import tempfile
from pathlib import Path


URL = "https://wpvapppcprt01.itap.purdue.edu:9192/user"
FIREFOX = "@firefox@"
SSH = "@ssh@"


def available_port():
    with socket.socket() as listener:
        listener.bind(("127.0.0.1", 0))
        return listener.getsockname()[1]


def exit_on_signal(signum, _frame):
    raise SystemExit(128 + signum)


def run_quiet(command):
    with tempfile.TemporaryFile(mode="w+", encoding="utf-8") as log:
        result = subprocess.run(
            command,
            check=False,
            stdin=subprocess.DEVNULL,
            stdout=log,
            stderr=subprocess.STDOUT,
        )
        if result.returncode != 0:
            log.seek(0)
            output = log.read()
            if output:
                print(output, file=sys.stderr, end="" if output.endswith("\n") else "\n")
            result.check_returncode()


def firefox_command(profile_dir):
    return [
        FIREFOX,
        "-kiosk",
        "--no-remote",
        "--profile",
        profile_dir,
        URL,
    ]


def main():
    for signum in (signal.SIGHUP, signal.SIGINT, signal.SIGTERM):
        signal.signal(signum, exit_on_signal)

    port = available_port()

    with tempfile.TemporaryDirectory(prefix="papercut-") as profile_dir:
        control_socket = Path(profile_dir) / "ssh-control"
        ssh_control = [SSH, "-S", str(control_socket)]
        (Path(profile_dir) / "user.js").write_text(
            '\n'.join(
                [
                    'user_pref("network.proxy.type", 1);',
                    'user_pref("network.proxy.socks", "127.0.0.1");',
                    f'user_pref("network.proxy.socks_port", {port});',
                    'user_pref("network.proxy.socks_version", 5);',
                    'user_pref("network.proxy.socks_remote_dns", true);',
                    'user_pref("signon.rememberSignons", false);',
                    'user_pref("signon.autofillForms", false);',
                    'user_pref("signon.generation.enabled", false);',
                    'user_pref("browser.shell.checkDefaultBrowser", false);',
                    'user_pref("browser.startup.homepage_override.mstone", "ignore");',
                    'user_pref("browser.uitour.enabled", false);',
                    'user_pref("trailhead.firstrun.didSeeAboutWelcome", true);',
                    'user_pref("browser.rights.3.shown", true);',
                    'user_pref("browser.link.open_newwindow", 1);',
                    'user_pref("browser.link.open_newwindow.restriction", 0);',
                    'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);',
                ]
            )
            + '\n'
        )
        chrome_dir = Path(profile_dir) / "chrome"
        chrome_dir.mkdir()
        (chrome_dir / "userChrome.css").write_text(
            "#navigator-toolbox { display: none !important; }\n"
        )

        try:
            run_quiet(
                [
                    *ssh_control,
                    "-M",
                    "-fN",
                    "-D",
                    f"127.0.0.1:{port}",
                    "-o",
                    "ExitOnForwardFailure=yes",
                    "data",
                ]
            )
            run_quiet(firefox_command(profile_dir))
        finally:
            subprocess.run(
                [*ssh_control, "-O", "exit", "data"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=False,
            )


if __name__ == "__main__":
    main()
