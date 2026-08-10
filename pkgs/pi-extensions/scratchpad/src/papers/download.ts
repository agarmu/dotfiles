import * as fs from "node:fs";

const MAX_DOWNLOAD_BYTES = 100 * 1024 * 1024;

export async function downloadFile(url: string, destination: string): Promise<number> {
  let current = new URL(url);
  for (let redirect = 0; redirect < 5; redirect += 1) {
    const result = await downloadAttempt(current, destination);
    if (typeof result === "number") return result;
    current = result;
  }
  throw new Error("Too many download redirects");
}

async function downloadAttempt(url: URL, destination: string): Promise<number | URL> {
  if (!/^https?:$/.test(url.protocol)) throw new Error("Only HTTP(S) paper URLs are supported");
  const response = await fetch(url, { redirect: "manual", headers: { "user-agent": "pi-scratchpad/0.2.0 (paper download)" } });
  if (response.status >= 300 && response.status < 400) return redirectTarget(response, url);
  if (!response.ok || !response.body) throw new Error(`${response.status} ${response.statusText}`);
  rejectLargeContentLength(response);
  return writeResponse(response, destination);
}

function redirectTarget(response: Response, current: URL): URL {
  const location = response.headers.get("location");
  if (!location) throw new Error("Download redirect had no location");
  return new URL(location, current);
}

function rejectLargeContentLength(response: Response): void {
  const length = Number(response.headers.get("content-length") || 0);
  if (length > MAX_DOWNLOAD_BYTES) throw new Error("Refusing downloads larger than 100 MiB");
}

async function writeResponse(response: Response, destination: string): Promise<number> {
  const file = await fs.promises.open(destination, "w", 0o600);
  let bytes = 0;
  try {
    for await (const chunk of response.body as any) {
      bytes += chunk.length;
      if (bytes > MAX_DOWNLOAD_BYTES) throw new Error("Download exceeded 100 MiB");
      await file.write(chunk);
    }
  } finally {
    await file.close();
  }
  return bytes;
}
