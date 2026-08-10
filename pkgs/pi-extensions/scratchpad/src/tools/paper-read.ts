import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { extractCorpusRange, preparePaperCorpus } from "../papers/corpus.ts";
import { PaperReadParameters } from "../schemas.ts";
import { ensureScratchpad } from "../session.ts";

export function registerPaperRead(pi: ExtensionAPI): void {
  pi.registerTool({
    name: "paper_read",
    label: "Read Paper",
    description: "Prepare a line-addressed corpus or deterministically extract a bounded range chosen by a cheap subagent.",
    promptSnippet: "Locate paper sections cheaply, then extract exact line ranges",
    promptGuidelines: [
      "Prepare first, then use the weakest/free subagent model to return only JSON [{label,start,end}] with inclusive 1-based lines.",
      "Extract those exact positions; the indexing subagent must not quote or summarize the paper.",
    ],
    parameters: PaperReadParameters,
    async execute(_toolCallId, params) {
      const scratchpad = await ensureScratchpad();
      if (params.action === "prepare") return prepareResult(params.path, params.request, scratchpad);
      if (params.start === undefined || params.end === undefined) return errorResult("extract requires inclusive start and end line positions");
      return extractResult(params.path, params.start, params.end, params.maxChars || 12000, scratchpad);
    },
  });
}

async function prepareResult(path: string, request: string | undefined, scratchpad: string) {
  try {
    const corpus = await preparePaperCorpus(path, scratchpad);
    const task = indexingTask(corpus.path, request);
    const configuredModel = process.env.PI_PAPER_INDEX_MODEL?.trim();
    const modelInstruction = configuredModel ? `Use model ${configuredModel}.` : "Use the weakest or free model configured in Pi.";
    return {
      content: [{ type: "text" as const, text: `Prepared ${corpus.lines} lines (${corpus.bytes} bytes) at:\n${corpus.path}\n\nNext: spawn a read-only subagent. ${modelInstruction}\nTask:\n${task}\n\nThen extract the chosen start/end positions with paper_read.` }],
      details: { corpusPath: corpus.path, lines: corpus.lines, bytes: corpus.bytes, indexingTask: task, suggestedModel: configuredModel || "weakest/free configured model" },
    };
  } catch (error) {
    return errorResult(`Could not prepare paper corpus: ${errorMessage(error)}`);
  }
}

function indexingTask(corpusPath: string, request?: string): string {
  const target = request?.trim() || "Identify the sections, theorem statements, definitions, and proofs relevant to the current question.";
  return `Read ${corpusPath} and locate: ${target}\nReturn only a JSON array shaped {\"label\":string,\"start\":number,\"end\":number}. Positions are inclusive 1-based lines in that exact file. Do not quote, summarize, or copy the paper. Keep ranges tight; return at most 8.`;
}

async function extractResult(path: string, start: number, end: number, maxChars: number, scratchpad: string) {
  try {
    const range = await extractCorpusRange(path, scratchpad, start, end, maxChars);
    const header = `[${range.start}-${range.end} of requested ${start}-${end}${range.truncated ? "; truncated" : ""}]\n`;
    return { content: [{ type: "text" as const, text: header + range.text }], details: { corpusPath: path, ...range, text: undefined, maxChars } };
  } catch (error) {
    return errorResult(`Could not extract paper range: ${errorMessage(error)}`);
  }
}

function errorResult(message: string) {
  return { content: [{ type: "text" as const, text: message }], isError: true };
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
