import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { PaperCache } from "./papers/model.ts";
import { configureSandbox, ensureScratchpad, scratchpadPath } from "./session.ts";
import { registerPaperDetails } from "./tools/paper-details.ts";
import { registerPaperDownload } from "./tools/paper-download.ts";
import { registerPaperRead } from "./tools/paper-read.ts";
import { registerPaperSearch } from "./tools/paper-search.ts";
import { registerScratchpadTool } from "./tools/scratchpad.ts";

export default async function registerScratchpad(pi: ExtensionAPI) {
  await configureSandbox();
  const paperCache = new PaperCache();
  let directory = scratchpadPath();

  pi.on("session_start", async () => {
    paperCache.clear();
    directory = await ensureScratchpad();
  });

  pi.on("before_agent_start", async (event) => {
    directory = await ensureScratchpad();
    return { systemPrompt: appendScratchpadPrompt(event.systemPrompt, directory) };
  });

  registerPaperSearch(pi, paperCache);
  registerPaperDetails(pi, paperCache);
  registerPaperDownload(pi);
  registerPaperRead(pi);
  registerScratchpadTool(pi);
}

function appendScratchpadPrompt(systemPrompt: string, directory: string): string {
  const papers = path.join(directory, "papers");
  return `${systemPrompt}\n\n## Session scratchpad\nUse the private session scratchpad at \`${directory}\` for temporary work outside the project, including files and directories you might otherwise put under /tmp; do not use /tmp for agent-created temporary work. Academic downloads are stored under \`${papers}\`; use paper_search, paper_details, paper_download, and paper_read for literature workflows.`;
}
