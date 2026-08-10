import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const MAX_RESULT_BYTES = 64 * 1024;
const MAX_STDERR_BYTES = 8 * 1024;

const SubagentsParams = Type.Object({
	task: Type.String({ description: "Self-contained task for the child agent." }),
	systemPrompt: Type.Optional(
		Type.String({
			description:
				"Optional temporary role/instructions for this child only. It is appended to Pi's normal system prompt.",
		}),
	),
	label: Type.Optional(Type.String({ description: "Short display name for this otherwise anonymous child." })),
	tools: Type.Optional(
		Type.Array(Type.String(), {
			description: "Optional allowlist of child tool names. Omit to use Pi's normal active tools.",
		}),
	),
	model: Type.Optional(Type.String({ description: "Optional Pi model pattern for the child." })),
	thinking: Type.Optional(
		Type.Union([
			Type.Literal("off"),
			Type.Literal("minimal"),
			Type.Literal("low"),
			Type.Literal("medium"),
			Type.Literal("high"),
			Type.Literal("xhigh"),
			Type.Literal("max"),
		]),
	),
	cwd: Type.Optional(Type.String({ description: "Optional working directory for the child." })),
});

type SubagentDetails = {
	label: string;
	task: string;
	exitCode: number;
	stderr: string;
	output: string;
};

function cap(text: string, maxBytes: number): string {
	if (Buffer.byteLength(text, "utf8") <= maxBytes) return text;
	let result = text.slice(0, maxBytes);
	while (Buffer.byteLength(result, "utf8") > maxBytes) result = result.slice(0, -1);
	return `${result}\n\n[Output truncated.]`;
}

function getPiInvocation(args: string[]): { command: string; args: string[] } {
	const currentScript = process.argv[1];
	const isBunVirtualScript = currentScript?.startsWith("/$bunfs/root/");
	if (currentScript && !isBunVirtualScript && fs.existsSync(currentScript)) {
		return { command: process.execPath, args: [currentScript, ...args] };
	}

	const executable = path.basename(process.execPath).toLowerCase();
	if (!/^(node|bun)(\.exe)?$/.test(executable)) return { command: process.execPath, args };
	return { command: "pi", args };
}

async function writeSystemPrompt(prompt: string): Promise<{ directory: string; file: string }> {
	const directory = await fs.promises.mkdtemp(path.join(os.tmpdir(), "pi-subagents-"));
	const file = path.join(directory, "system-prompt.md");
	await fs.promises.writeFile(file, prompt, { encoding: "utf8", mode: 0o600 });
	return { directory, file };
}

function finalText(message: unknown): string | undefined {
	if (!message || typeof message !== "object") return undefined;
	const candidate = message as { role?: unknown; content?: unknown };
	if (candidate.role !== "assistant" || !Array.isArray(candidate.content)) return undefined;
	const text = candidate.content
		.filter((part): part is { type: "text"; text: string } =>
			Boolean(part && typeof part === "object" && (part as { type?: unknown }).type === "text" && typeof (part as { text?: unknown }).text === "string"),
		)
		.map((part) => part.text)
		.join("\n");
	return text || undefined;
}

export default function registerSubagents(pi: ExtensionAPI) {
	pi.registerTool({
		name: "subagents",
		label: "Subagents",
		description:
			"Run one isolated, one-shot Pi child agent without requiring a named agent definition. The child receives only this task and optional temporary instructions; use it for bounded independent research, review, or implementation.",
		promptSnippet: "Delegate one bounded task to an isolated Pi child",
		promptGuidelines: [
			"Use subagents only for a bounded task that benefits from an isolated context window.",
			"Give subagents all context it needs in task; the child does not inherit the parent conversation.",
		],
		parameters: SubagentsParams,

		async execute(_toolCallId, params, signal, onUpdate, ctx) {
			const label = params.label?.trim() || "anonymous";
			const args = ["--mode", "json", "--print", "--no-session", "--exclude-tools", "subagents"];
			if (params.model?.trim()) args.push("--model", params.model.trim());
			if (params.thinking) args.push("--thinking", params.thinking);
			if (params.tools?.length) args.push("--tools", params.tools.join(","));

			let temporaryPrompt: { directory: string; file: string } | undefined;
			try {
				if (params.systemPrompt?.trim()) {
					temporaryPrompt = await writeSystemPrompt(params.systemPrompt);
					args.push("--append-system-prompt", temporaryPrompt.file);
				}
				args.push(params.task);

				const output: string[] = [];
				let stderr = "";
				let buffer = "";
				let aborted = false;
				const invocation = getPiInvocation(args);
				const exitCode = await new Promise<number>((resolve) => {
					const child = spawn(invocation.command, invocation.args, {
						cwd: params.cwd || ctx.cwd,
						shell: false,
						stdio: ["ignore", "pipe", "pipe"],
					});

					const consume = (line: string) => {
						if (!line.trim()) return;
						try {
							const event = JSON.parse(line) as { type?: string; message?: unknown };
							if (event.type !== "message_end") return;
							const text = finalText(event.message);
							if (!text) return;
							output.push(text);
							onUpdate?.({ content: [{ type: "text", text: cap(text, MAX_RESULT_BYTES) }] });
						} catch {
							// JSON mode emits one event per line; ignore malformed diagnostic lines.
						}
					};

					child.stdout.on("data", (data: Buffer) => {
						buffer += data.toString("utf8");
						const lines = buffer.split("\n");
						buffer = lines.pop() || "";
						for (const line of lines) consume(line);
					});
					child.stderr.on("data", (data: Buffer) => {
						stderr = cap(stderr + data.toString("utf8"), MAX_STDERR_BYTES);
					});
					child.on("error", (error) => {
						stderr = cap(`${stderr}\n${error.message}`.trim(), MAX_STDERR_BYTES);
					});
					child.on("close", (code) => {
						consume(buffer);
						resolve(code ?? 1);
					});

					const abort = () => {
						aborted = true;
						child.kill("SIGTERM");
						setTimeout(() => child.kill("SIGKILL"), 5_000).unref();
					};
					if (signal?.aborted) abort();
					else signal?.addEventListener("abort", abort, { once: true });
				});

				const result = cap(output.at(-1) || "(The child produced no final text.)", MAX_RESULT_BYTES);
				const details: SubagentDetails = { label, task: params.task, exitCode, stderr, output: result };
				if (aborted) {
					return { content: [{ type: "text", text: "Subagent was aborted." }], details, isError: true };
				}
				if (exitCode !== 0) {
					return {
						content: [{ type: "text", text: `Subagent failed (exit ${exitCode}).\n${stderr || result}` }],
						details,
						isError: true,
					};
				}
				return { content: [{ type: "text", text: result }], details };
			} finally {
				if (temporaryPrompt) await fs.promises.rm(temporaryPrompt.directory, { recursive: true, force: true });
			}
		},
	});
}
