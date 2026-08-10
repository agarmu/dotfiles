import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import { randomUUID } from "node:crypto";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { StringDecoder } from "node:string_decoder";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const DEFAULT_READ_BYTES = 12 * 1024;
const MAX_READ_BYTES = 32 * 1024;
const MAX_RETAINED_BYTES = 256 * 1024;
const MAX_STDERR_BYTES = 8 * 1024;
const MAX_CHILDREN = 16;
const RPC_TIMEOUT_MS = 15_000;

type Status = "starting" | "running" | "idle" | "exited" | "stopped" | "error";
type Pending = { resolve: (event: RpcEvent) => void; reject: (error: Error) => void; timer: NodeJS.Timeout };
type RpcEvent = { id?: string; type?: string; command?: string; success?: boolean; error?: string; message?: unknown; assistantMessageEvent?: { type?: string; delta?: string } };

type Child = {
	id: string;
	label: string;
	process: ChildProcessWithoutNullStreams;
	status: Status;
	createdAt: number;
	cwd: string;
	buffer: Buffer;
	baseCursor: number;
	nextCursor: number;
	stderr: string;
	pending: Map<string, Pending>;
	stdoutBuffer: string;
	stdoutDecoder: StringDecoder;
	tempDirectory?: string;
	exitCode?: number;
};

const Params = Type.Object({
	action: Type.Union([
		Type.Literal("spawn"), Type.Literal("send"), Type.Literal("read"), Type.Literal("list"), Type.Literal("stop"),
	]),
	id: Type.Optional(Type.String({ description: "Child id (send/read/stop)." })),
	task: Type.Optional(Type.String({ description: "Initial task (spawn) or follow-up (send)." })),
	label: Type.Optional(Type.String({ description: "Short child name (spawn)." })),
	systemPrompt: Type.Optional(Type.String({ description: "Temporary appended instructions (spawn)." })),
	tools: Type.Optional(Type.Array(Type.String(), { description: "Child tool allowlist (spawn)." })),
	model: Type.Optional(Type.String({ description: "Pi model pattern (spawn)." })),
	thinking: Type.Optional(Type.Union([
		Type.Literal("off"), Type.Literal("minimal"), Type.Literal("low"), Type.Literal("medium"),
		Type.Literal("high"), Type.Literal("xhigh"), Type.Literal("max"),
	])),
	cwd: Type.Optional(Type.String({ description: "Child working directory (spawn)." })),
	cursor: Type.Optional(Type.Integer({ minimum: 0, description: "Absolute byte cursor (read)." })),
	maxBytes: Type.Optional(Type.Integer({ minimum: 1, maximum: MAX_READ_BYTES, description: "Bytes to return (read)." })),
});

function invocation(args: string[]): { command: string; args: string[] } {
	const script = process.argv[1];
	if (script && !script.startsWith("/$bunfs/root/") && fs.existsSync(script)) return { command: process.execPath, args: [script, ...args] };
	const executable = path.basename(process.execPath).toLowerCase();
	return /^(node|bun)(\.exe)?$/.test(executable) ? { command: "pi", args } : { command: process.execPath, args };
}

function append(child: Child, text: string) {
	if (!text) return;
	const chunk = Buffer.from(text, "utf8");
	child.buffer = Buffer.concat([child.buffer, chunk]);
	child.nextCursor += chunk.length;
	if (child.buffer.length > MAX_RETAINED_BYTES) {
		const drop = child.buffer.length - MAX_RETAINED_BYTES;
		child.buffer = child.buffer.subarray(drop);
		child.baseCursor += drop;
	}
}

function assistantText(message: unknown): string | undefined {
	if (!message || typeof message !== "object") return undefined;
	const value = message as { role?: unknown; content?: unknown };
	if (value.role !== "assistant" || !Array.isArray(value.content)) return undefined;
	const text = value.content
		.filter((part): part is { type: "text"; text: string } => Boolean(part && typeof part === "object" && (part as { type?: unknown }).type === "text" && typeof (part as { text?: unknown }).text === "string"))
		.map((part) => part.text).join("\n");
	return text || undefined;
}

async function makePromptFile(prompt: string): Promise<{ directory: string; file: string }> {
	const directory = await fs.promises.mkdtemp(path.join(os.tmpdir(), "pi-subagents-"));
	const file = path.join(directory, "system-prompt.md");
	await fs.promises.writeFile(file, prompt, { encoding: "utf8", mode: 0o600 });
	return { directory, file };
}

function sendRpc(child: Child, command: Record<string, unknown>): Promise<RpcEvent> {
	if (child.process.exitCode !== null || !child.process.stdin.writable) return Promise.reject(new Error("child is not running"));
	const id = randomUUID();
	return new Promise((resolve, reject) => {
		const timer = setTimeout(() => {
			child.pending.delete(id);
			reject(new Error(`RPC ${String(command.type)} timed out`));
		}, RPC_TIMEOUT_MS);
		child.pending.set(id, { resolve, reject, timer });
		child.process.stdin.write(`${JSON.stringify({ ...command, id })}\n`, (error) => {
			if (!error) return;
			clearTimeout(timer);
			child.pending.delete(id);
			reject(error);
		});
	});
}

function stopChild(child: Child, status: Status = "stopped") {
	child.status = status;
	for (const pending of child.pending.values()) {
		clearTimeout(pending.timer);
		pending.reject(new Error("child stopped"));
	}
	child.pending.clear();
	if (child.process.exitCode === null) {
		child.process.kill("SIGTERM");
		setTimeout(() => child.process.exitCode === null && child.process.kill("SIGKILL"), 5_000).unref();
	}
	if (child.tempDirectory) void fs.promises.rm(child.tempDirectory, { recursive: true, force: true });
}

export default function registerSubagents(pi: ExtensionAPI) {
	const children = new Map<string, Child>();

	pi.on("session_shutdown", async () => {
		for (const child of children.values()) stopChild(child);
		children.clear();
	});

	pi.registerTool({
		name: "subagents",
		label: "Subagents",
		description: "Manage isolated persistent Pi children. Spawn, send follow-ups, read bounded output by cursor, list, or stop.",
		promptSnippet: "Use persistent isolated children for independent work; poll output with bounded reads",
		promptGuidelines: ["Tasks must be self-contained. After spawn, use read with returned cursor until more=false; send follow-ups when needed; stop finished children."],
		parameters: Params,
		async execute(_callId, params, signal, _onUpdate, ctx) {
			if (params.action === "list") {
				const rows = [...children.values()].map((child) => ({ id: child.id, label: child.label, status: child.status, unreadFromStart: child.nextCursor - child.baseCursor, retainedFrom: child.baseCursor }));
				return { content: [{ type: "text", text: rows.length ? JSON.stringify(rows) : "No subagents." }], details: { children: rows } };
			}

			if (params.action === "spawn") {
				if (!params.task?.trim()) return { content: [{ type: "text", text: "spawn requires task" }], isError: true };
				if (children.size >= MAX_CHILDREN) return { content: [{ type: "text", text: `At most ${MAX_CHILDREN} subagents may be retained; stop one first.` }], isError: true };
				const id = randomUUID().slice(0, 8);
				const label = params.label?.trim() || `subagent-${id}`;
				const args = ["--mode", "rpc", "--no-session", "--name", label, "--exclude-tools", "subagents"];
				if (params.model?.trim()) args.push("--model", params.model.trim());
				if (params.thinking) args.push("--thinking", params.thinking);
				if (params.tools?.length) args.push("--tools", params.tools.join(","));
				let promptFile: { directory: string; file: string } | undefined;
				if (params.systemPrompt?.trim()) {
					promptFile = await makePromptFile(params.systemPrompt.trim());
					args.push("--append-system-prompt", promptFile.file);
				}
				const cmd = invocation(args);
				const proc = spawn(cmd.command, cmd.args, { cwd: params.cwd || ctx.cwd, shell: false, stdio: ["pipe", "pipe", "pipe"] });
				const child: Child = { id, label, process: proc, status: "starting", createdAt: Date.now(), cwd: params.cwd || ctx.cwd, buffer: Buffer.alloc(0), baseCursor: 0, nextCursor: 0, stderr: "", pending: new Map(), stdoutBuffer: "", stdoutDecoder: new StringDecoder("utf8"), tempDirectory: promptFile?.directory };
				children.set(id, child);

				const consume = (line: string) => {
					if (!line.trim()) return;
					let event: RpcEvent;
					try { event = JSON.parse(line) as RpcEvent; } catch { return; }
					if (event.type === "response" && event.id) {
						const pending = child.pending.get(event.id);
						if (pending) { clearTimeout(pending.timer); child.pending.delete(event.id); event.success === false ? pending.reject(new Error(event.error || "RPC command failed")) : pending.resolve(event); }
					}
					if (event.type === "agent_start") child.status = "running";
					if (event.type === "agent_settled") child.status = "idle";
					if (event.type === "message_end") {
						const text = assistantText(event.message);
						if (text) append(child, `${text}\n`);
					}
				};
				proc.stdout.on("data", (data: Buffer) => {
					child.stdoutBuffer += child.stdoutDecoder.write(data);
					while (true) { const at = child.stdoutBuffer.indexOf("\n"); if (at < 0) break; let line = child.stdoutBuffer.slice(0, at); child.stdoutBuffer = child.stdoutBuffer.slice(at + 1); if (line.endsWith("\r")) line = line.slice(0, -1); consume(line); }
				});
				proc.stderr.on("data", (data: Buffer) => { child.stderr = (child.stderr + data.toString("utf8")).slice(-MAX_STDERR_BYTES); });
				proc.on("error", (error) => { child.status = "error"; append(child, `[error] ${error.message}\n`); });
				proc.on("close", (code) => {
					child.exitCode = code ?? 1;
					if (child.status !== "stopped") child.status = code === 0 ? "exited" : "error";
					append(child, `[${child.status}; exit ${child.exitCode}]\n`);
					for (const pending of child.pending.values()) { clearTimeout(pending.timer); pending.reject(new Error(`child exited (${child.exitCode})`)); }
					child.pending.clear();
					if (child.tempDirectory) void fs.promises.rm(child.tempDirectory, { recursive: true, force: true });
				});

				ctx.ui.notify(`Started subagent “${label}” (${id})${params.model ? ` · ${params.model}` : ""}`, "info");
				try {
					if (signal?.aborted) throw new Error("spawn aborted");
					await sendRpc(child, { type: "get_state" });
					if (child.tempDirectory) {
						await fs.promises.rm(child.tempDirectory, { recursive: true, force: true });
						child.tempDirectory = undefined;
					}
					await sendRpc(child, { type: "prompt", message: params.task.trim() });
					return { content: [{ type: "text", text: `Started ${label} (${id}). Read from cursor 0.` }], details: { id, label, status: child.status, cursor: 0 } };
				} catch (error) {
					stopChild(child, "error");
					children.delete(id);
					return { content: [{ type: "text", text: `Failed to start ${label}: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
				}
			}

			if (!params.id) return { content: [{ type: "text", text: `${params.action} requires id` }], isError: true };
			const child = children.get(params.id);
			if (!child) return { content: [{ type: "text", text: `Unknown subagent: ${params.id}` }], isError: true };

			if (params.action === "stop") {
				stopChild(child);
				children.delete(child.id);
				return { content: [{ type: "text", text: `Stopped ${child.label} (${child.id}).` }], details: { id: child.id, status: child.status } };
			}
			if (params.action === "send") {
				if (!params.task?.trim()) return { content: [{ type: "text", text: "send requires task" }], isError: true };
				try {
					await sendRpc(child, { type: "prompt", message: params.task.trim(), ...(child.status === "running" ? { streamingBehavior: "followUp" } : {}) });
					return { content: [{ type: "text", text: `Sent to ${child.label} (${child.id}).` }], details: { id: child.id, status: child.status } };
				} catch (error) { return { content: [{ type: "text", text: `Send failed: ${error instanceof Error ? error.message : String(error)}` }], isError: true }; }
			}

			const requested = params.cursor ?? child.baseCursor;
			const cursor = Math.min(Math.max(requested, child.baseCursor), child.nextCursor);
			const maxBytes = params.maxBytes ?? DEFAULT_READ_BYTES;
			const start = cursor - child.baseCursor;
			const chunk = child.buffer.subarray(start, Math.min(start + maxBytes, child.buffer.length));
			const nextCursor = cursor + chunk.length;
			const lost = requested < child.baseCursor;
			const header = lost ? `[Earlier output expired; resumed at ${child.baseCursor}.]\n` : "";
			const text = header + chunk.toString("utf8") || "(no new output)";
			return { content: [{ type: "text", text }], details: { id: child.id, label: child.label, status: child.status, cursor: nextCursor, more: nextCursor < child.nextCursor, retainedFrom: child.baseCursor, end: child.nextCursor, lost } };
		},
	});
}
