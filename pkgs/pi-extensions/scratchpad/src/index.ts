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

  registerPaperSearch(pi, paperCache);
  registerPaperDetails(pi, paperCache);
  registerPaperDownload(pi);
  registerPaperRead(pi);
  registerScratchpadTool(pi);
}
