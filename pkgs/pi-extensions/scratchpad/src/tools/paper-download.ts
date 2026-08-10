import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { downloadFile } from "../papers/download.ts";
import { safeFilename } from "../papers/model.ts";
import { PaperDownloadParameters } from "../schemas.ts";
import { ensureScratchpad } from "../session.ts";

export function registerPaperDownload(pi: ExtensionAPI): void {
  pi.registerTool({
    name: "paper_download",
    label: "Download Paper",
    description: "Download a paper PDF or arXiv source archive into the session scratchpad.",
    promptSnippet: "Download a paper PDF or source archive",
    promptGuidelines: ["Prefer arxivId; use source for TeX and figures. On failure, report the supplied browser fallback."],
    parameters: PaperDownloadParameters,
    async execute(_toolCallId, params) {
      if (!params.url && !params.arxivId) return errorResult("Provide url or arxivId");
      const format = params.format || "pdf";
      const arxivId = cleanArxivId(params.arxivId);
      const url = params.url?.trim() || arxivUrl(arxivId, format);
      return downloadResult(url, arxivId, format, params.filename?.trim());
    },
  });
}

async function downloadResult(url: string, arxivId: string | undefined, format: "pdf" | "source", requestedFilename?: string) {
  const targetDirectory = path.join(await ensureScratchpad(), "papers");
  await fs.promises.mkdir(targetDirectory, { recursive: true, mode: 0o700 });
  const destination = path.join(targetDirectory, safeFilename(requestedFilename || defaultFilename(url, arxivId, format)));
  try {
    const bytes = await downloadFile(url, destination);
    return { content: [{ type: "text" as const, text: `Downloaded ${bytes} bytes to ${destination}\nURL: ${url}` }], details: { path: destination, url, bytes, format } };
  } catch (error) {
    await fs.promises.unlink(destination).catch(() => undefined);
    const reason = error instanceof Error ? error.message : String(error);
    return { content: [{ type: "text" as const, text: `Could not download automatically: ${reason}\n\nOpen in a browser:\n${url}\n\nPlace the file at:\n${destination}` }], details: { url, destination, format, error: reason }, isError: true };
  }
}

function cleanArxivId(value?: string): string | undefined {
  return value?.trim().replace(/^https?:\/\/(?:export\.)?arxiv\.org\/(?:abs|pdf|e-print)\//, "").replace(/\.pdf$/, "") || undefined;
}

function arxivUrl(identifier: string | undefined, format: "pdf" | "source"): string {
  return `https://export.arxiv.org/${format === "source" ? "e-print" : "pdf"}/${identifier}${format === "pdf" ? ".pdf" : ""}`;
}

function defaultFilename(url: string, arxivId: string | undefined, format: "pdf" | "source"): string {
  if (arxivId) return `${arxivId.replaceAll("/", "-")}.${format === "source" ? "tar" : "pdf"}`;
  const basename = safeFilename(new URL(url).pathname.split("/").pop() || "paper");
  return `${basename}${format === "source" ? ".tar" : ""}`;
}

function errorResult(message: string) {
  return { content: [{ type: "text" as const, text: message }], isError: true };
}
