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

  pi.on("before_agent_start", (event) => ({
    systemPrompt: [
      event.systemPrompt,
      "## Session scratchpad",
      `Use ${directory} for all agent-created temporary files, cloned repositories, downloads, generated artifacts, and experiments that do not belong in the project.`,
      "Do not use /tmp for agent-created work. OS- or application-created temporary files, such as Pi clipboard images, may remain in the platform temporary directory.",
      "Treat /nix/store as a runtime implementation detail: do not recursively browse or search it. Prefer source files in the current project, and read an exact store path only when the task specifically requires installed-package internals.",
    ].join("\n\n"),
  }));

  registerPaperSearch(pi, paperCache);
  registerPaperDetails(pi, paperCache);
  registerPaperDownload(pi);
  registerPaperRead(pi);
  registerScratchpadTool(pi);
}
