import * as fs from "node:fs";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { ScratchpadParameters } from "../schemas.ts";
import { ensureScratchpad } from "../session.ts";

export function registerScratchpadTool(pi: ExtensionAPI): void {
  pi.registerTool({
    name: "scratchpad",
    label: "Scratchpad",
    description: "Return the private session scratchpad path or list its top-level contents.",
    promptSnippet: "Use the private scratchpad for temporary work",
    parameters: ScratchpadParameters,
    async execute(_toolCallId, params) {
      const directory = await ensureScratchpad();
      if (params.action !== "list") return { content: [{ type: "text", text: directory }], details: { path: directory } };
      const entries = await fs.promises.readdir(directory, { withFileTypes: true });
      const listing = entries.map((entry) => `${entry.isDirectory() ? "d" : "f"} ${entry.name}`).join("\n");
      return { content: [{ type: "text", text: `${directory}\n${listing || "(empty)"}` }], details: { path: directory, entries: entries.map((entry) => entry.name) } };
    },
  });

  pi.registerCommand("scratchpad", {
    description: "Show the per-session scratchpad path",
    handler: async (_args, ctx) => ctx.ui.notify(await ensureScratchpad(), "info"),
  });
}
