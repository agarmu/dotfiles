import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import { randomUUID } from "node:crypto";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { StringDecoder } from "node:string_decoder";
import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Container, Text } from "@earendil-works/pi-tui";
import { Type } from "typebox";

const DEFAULT_INSPECT_BYTES = 4 * 1024;
const MAX_INSPECT_BYTES = 32 * 1024;
const MAX_RETAINED_BYTES = 256 * 1024;
const MAX_STDERR_BYTES = 8 * 1024;
const MAX_CHILDREN = 16;
const RPC_TIMEOUT_MS = 15_000;

type Status = "starting" | "running" | "idle" | "exited" | "stopped" | "error";
type Pending = { resolve: (event: RpcEvent) => void; reject: (error: Error) => void; timer: NodeJS.Timeout };
type RpcEvent = {
	id?: string;
	type?: string;
	command?: string;
	success?: boolean;
	error?: string;
	message?: unknown;
	data?: unknown;
};
type Prompt = { at: number; text: string };

type Child = {
	id: string;
	label: string;
	model: string;
	requestedModel?: string;
	thinking?: string;
	process: ChildProcessWithoutNullStreams;
	status: Status;
	createdAt: number;
	statusChangedAt: number;
	lastStartedAt?: number;
	lastSettledAt?: number;
	cwd: string;
	prompts: Prompt[];
	buffer: Buffer;
	baseCursor: number;
	nextCursor: number;
	inspectionCursor: number;
	stderr: string;
	pending: Map<string, Pending>;
	waiters: Set<() => void>;
	stdoutBuffer: string;
	stdoutDecoder: StringDecoder;
	tempDirectory?: string;
	exitCode?: number;
};

const Params = Type.Object({
	action: StringEnum(["spawn", "send", "poll", "inspect", "list", "read", "wait_any", "wait_specific", "stop"] as const, {
		description: "poll/list/wait_any/wait_specific return metadata only; inspect/read return bounded output explicitly. wait_any waits for the first child; wait_specific waits for the named child.",
	}),
	id: Type.Optional(Type.String({ description: "Child id (send/poll/inspect/read/wait_specific/stop)." })),
	task: Type.Optional(Type.String({ description: "Initial task (spawn) or follow-up (send)." })),
	label: Type.Optional(Type.String({ description: "Short child name (spawn)." })),
	systemPrompt: Type.Optional(Type.String({ description: "Temporary appended instructions (spawn)." })),
	tools: Type.Optional(Type.Array(Type.String(), { description: "Child tool allowlist (spawn)." })),
	model: Type.Optional(Type.String({ description: "Pi model pattern (spawn)." })),
	thinking: Type.Optional(StringEnum(["off", "minimal", "low", "medium", "high", "xhigh", "max"] as const)),
	cwd: Type.Optional(Type.String({ description: "Child working directory (spawn)." })),
	cursor: Type.Optional(Type.Integer({ minimum: 0, description: "Absolute byte cursor (inspect/read)." })),
	maxBytes: Type.Optional(Type.Integer({ minimum: 1, maximum: MAX_INSPECT_BYTES, description: "Maximum output bytes for inspect/read." })),
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
		child.inspectionCursor = Math.max(child.inspectionCursor, child.baseCursor);
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

function resolvedModel(data: unknown): string | undefined {
	if (!data || typeof data !== "object") return undefined;
	const model = (data as { model?: unknown }).model;
	if (!model || typeof model !== "object") return undefined;
	const { provider, id } = model as { provider?: unknown; id?: unknown };
	if (typeof id !== "string") return undefined;
	return typeof provider === "string" ? `${provider}/${id}` : id;
}

function setStatus(child: Child, status: Status) {
	child.status = status;
	child.statusChangedAt = Date.now();
	if (status === "running") child.lastStartedAt = child.statusChangedAt;
	if (status === "idle") child.lastSettledAt = child.statusChangedAt;
	if (isReady(child)) {
		for (const waiter of child.waiters) waiter();
		child.waiters.clear();
	}
}

function waitForChild(child: Child, signal?: AbortSignal): Promise<void> {
	if (isReady(child)) return Promise.resolve();
	return new Promise((resolve, reject) => {
		const done = () => {
			child.waiters.delete(done);
			signal?.removeEventListener("abort", abort);
			resolve();
		};
		const abort = () => {
			child.waiters.delete(done);
			reject(new Error("wait aborted"));
		};
		child.waiters.add(done);
		if (signal?.aborted) abort();
		else signal?.addEventListener("abort", abort, { once: true });
	});
}

function isReady(child: Child): boolean {
	return child.status === "idle" || child.status === "exited" || child.status === "error" || child.status === "stopped";
}

function snapshot(child: Child, now = Date.now()) {
	return {
		id: child.id,
		label: child.label,
		model: child.model,
		thinking: child.thinking,
		status: child.status,
		ready: isReady(child),
		ageMs: now - child.createdAt,
		runningMs: child.status === "running" && child.lastStartedAt ? now - child.lastStartedAt : undefined,
		unreadBytes: child.nextCursor - Math.max(child.inspectionCursor, child.baseCursor),
		retainedBytes: child.nextCursor - child.baseCursor,
		cursor: child.inspectionCursor,
		end: child.nextCursor,
	};
}

function formatDuration(milliseconds: number): string {
	const seconds = Math.max(0, Math.floor(milliseconds / 1000));
	if (seconds < 60) return `${seconds}s`;
	const minutes = Math.floor(seconds / 60);
	if (minutes < 60) return `${minutes}m ${seconds % 60}s`;
	const hours = Math.floor(minutes / 60);
	return `${hours}h ${minutes % 60}m`;
}

function formatBytes(bytes: number): string {
	if (bytes < 1024) return `${bytes}B`;
	return `${(bytes / 1024).toFixed(bytes < 10 * 1024 ? 1 : 0)}KiB`;
}

function summaryLine(child: Child, now = Date.now()): string {
	const state = snapshot(child, now);
	const unread = state.unreadBytes ? ` · ${formatBytes(state.unreadBytes)} unread` : "";
	return `${child.label} (${child.id}) · ${child.model} · ${child.status} · ${formatDuration(state.ageMs)}${unread}`;
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
	setStatus(child, status);
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
	const activeWaits = new Set<() => void>();

	const waitWithBail = async <T>(signal: AbortSignal | undefined, operation: (waitSignal: AbortSignal) => Promise<T>): Promise<T> => {
		const controller = new AbortController();
		const abort = () => controller.abort();
		activeWaits.add(abort);
		signal?.addEventListener("abort", abort, { once: true });
		if (signal?.aborted) abort();
		try {
			return await operation(controller.signal);
		} finally {
			controller.abort();
			activeWaits.delete(abort);
			signal?.removeEventListener("abort", abort);
		}
	};

	const findChild = (query: string): Child | undefined => children.get(query) ?? [...children.values()].find((child) => child.label === query);

	pi.on("session_shutdown", async () => {
		for (const child of children.values()) stopChild(child);
		children.clear();
	});

	pi.registerCommand("subagents", {
		description: "View and inspect isolated subagents without adding their output to model context",
		handler: async (rawArgs, ctx) => {
			const args = rawArgs.trim().split(/\s+/).filter(Boolean);
			if (args[0] === "bail") {
				const count = activeWaits.size;
				for (const abort of activeWaits) abort();
				ctx.ui.notify(count ? `Bailed out of ${count} subagent wait${count === 1 ? "" : "s"}. Subagents are still running.` : "No active subagent waits.", "info");
				return;
			}
			if (children.size === 0) {
				ctx.ui.notify("No subagents.", "info");
				return;
			}

			let child = args[0] && args[0] !== "list" ? findChild(args[0]) : undefined;
			if (args[0] && args[0] !== "list" && !child) {
				ctx.ui.notify(`Unknown subagent: ${args[0]}`, "error");
				return;
			}

			if (!child && ctx.mode === "tui") {
				const choices = [...children.values()].map((candidate) => summaryLine(candidate));
				const selected = await ctx.ui.select("Subagents — select one to inspect", choices);
				if (!selected) return;
				child = [...children.values()][choices.indexOf(selected)];
			}
			if (!child) {
				ctx.ui.notify(`${[...children.values()].map((candidate) => summaryLine(candidate)).join("\n")}\nUse /subagents <id> [details|output|prompts|stderr|wait_specific|stop], or /subagents bail to interrupt active waits.`, "info");
				return;
			}

			let action = args[1];
			if (!action && ctx.mode === "tui") {
				action = await ctx.ui.select(`${child.label} · ${child.model}`, ["details", "output", "prompts", "stderr", "wait_any", "wait_specific", "stop"]);
			}
			action ||= "details";
			if (action === "wait_any" || action === "wait_specific") {
				try {
					if (action === "wait_any") {
						const selectedChildren = [...children.values()];
						ctx.ui.notify(`Waiting for any of ${selectedChildren.length} subagents…`, "info");
						const readyChild = await waitWithBail(undefined, (waitSignal) => Promise.race(selectedChildren.map(async (candidate) => {
							await waitForChild(candidate, waitSignal);
							return candidate;
						})));
						ctx.ui.notify(`${readyChild.label} is ${readyChild.status}.`, "info");
					} else {
						ctx.ui.notify(`Waiting for subagent ${child.label}…`, "info");
						await waitWithBail(undefined, (waitSignal) => waitForChild(child, waitSignal));
						ctx.ui.notify(`${child.label} is ${child.status}.`, "info");
					}
				} catch (error) {
					ctx.ui.notify(`Wait failed: ${error instanceof Error ? error.message : String(error)}`, "error");
				}
				return;
			}
			if (action === "stop") {
				if (ctx.mode === "tui" && !(await ctx.ui.confirm("Stop subagent?", `${child.label} (${child.id})`))) return;
				stopChild(child);
				children.delete(child.id);
				ctx.ui.notify(`Stopped ${child.label}.`, "info");
				return;
			}

			const state = snapshot(child);
			const content = action === "output"
				? child.buffer.toString("utf8") || "(no retained output)"
				: action === "stderr"
					? child.stderr || "(no stderr)"
					: action === "prompts"
						? child.prompts.map((prompt, index) => `# ${index + 1} · ${new Date(prompt.at).toLocaleString()}\n${prompt.text}`).join("\n\n")
						: [
							`Label: ${child.label}`,
							`ID: ${child.id}`,
							`Model: ${child.model}`,
							`Thinking: ${child.thinking ?? "default"}`,
							`Status: ${child.status}`,
							`Age: ${formatDuration(state.ageMs)}`,
							`Unread output: ${formatBytes(state.unreadBytes)}`,
							`Retained output: ${formatBytes(state.retainedBytes)}`,
							`Working directory: ${child.cwd}`,
						].join("\n");
			if (ctx.mode === "tui") await ctx.ui.editor(`${child.label} — ${action} (Esc to close)`, content);
			else ctx.ui.notify(content, "info");
		},
	});

	pi.registerTool({
		name: "subagents",
		label: "Subagents",
		description: "Manage isolated persistent Pi children. Poll status without retrieving output; explicitly inspect bounded output only when needed.",
		promptSnippet: "Spawn isolated children, poll readiness/status, and explicitly inspect bounded output",
		promptGuidelines: [
			"Use subagents poll after spawning to check readiness, runtime, and unread byte counts without retrieving output.",
			"Use subagents wait_any to wait for the first child to finish, or wait_specific with an id to wait for one named child.",
			"Waits are visible in the TUI and can be interrupted with /subagents bail; this leaves children running. If interrupted by a steer message, unless the steer explicitly says to stop, continue the work and wait again as needed.",
			"Use subagents inspect only when child output is needed; keep maxBytes small and continue from the returned cursor only as necessary.",
			"Subagent tasks must be self-contained; send follow-ups when needed and stop finished children.",
		],
		parameters: Params,
		renderCall(args, theme) {
			const byId = args.id ? children.get(args.id) : undefined;
			const byLabel = args.label ? [...children.values()].find((child) => child.label === args.label) : undefined;
			const child = byId ?? byLabel;
			const label = child?.label ?? args.label?.trim() ?? "subagents";
			const model = child?.model ?? args.model?.trim() ?? "default model";
			return new Text(`${theme.fg("toolTitle", theme.bold(label))} ${theme.fg("dim", `· ${model}`)}`, 0, 0);
		},
		renderResult() {
			return new Container();
		},
		async execute(_callId, params, signal, _onUpdate, ctx) {
			if (params.action === "poll" || params.action === "list") {
				const selected = params.id ? findChild(params.id) : undefined;
				if (params.id && !selected) return { content: [{ type: "text", text: `Unknown subagent: ${params.id}` }], isError: true };
				const selectedChildren = selected ? [selected] : [...children.values()];
				const rows = selectedChildren.map((child) => snapshot(child));
				const text = rows.length
					? rows.map((row) => `${row.id} ${row.label}: ${row.status}, ready=${row.ready}, ageMs=${row.ageMs}, unreadBytes=${row.unreadBytes}, model=${row.model}`).join("\n")
					: "No subagents.";
				return { content: [{ type: "text", text }], details: { children: rows } };
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
				const now = Date.now();
				const child: Child = {
					id, label, model: params.model?.trim() || "default model", requestedModel: params.model?.trim(), thinking: params.thinking,
					process: proc, status: "starting", createdAt: now, statusChangedAt: now, cwd: params.cwd || ctx.cwd,
					prompts: [{ at: now, text: params.task.trim() }], buffer: Buffer.alloc(0), baseCursor: 0, nextCursor: 0,
					inspectionCursor: 0, stderr: "", pending: new Map(), waiters: new Set(), stdoutBuffer: "", stdoutDecoder: new StringDecoder("utf8"),
					tempDirectory: promptFile?.directory,
				};
				children.set(id, child);

				const consume = (line: string) => {
					if (!line.trim()) return;
					let event: RpcEvent;
					try { event = JSON.parse(line) as RpcEvent; } catch { return; }
					if (event.type === "response" && event.id) {
						const pending = child.pending.get(event.id);
						if (pending) {
							clearTimeout(pending.timer);
							child.pending.delete(event.id);
							event.success === false ? pending.reject(new Error(event.error || "RPC command failed")) : pending.resolve(event);
						}
					}
					if (event.type === "agent_start") setStatus(child, "running");
					if (event.type === "agent_settled") setStatus(child, "idle");
					if (event.type === "message_end") {
						const text = assistantText(event.message);
						if (text) append(child, `${text}\n`);
					}
				};
				proc.stdout.on("data", (data: Buffer) => {
					child.stdoutBuffer += child.stdoutDecoder.write(data);
					while (true) {
						const at = child.stdoutBuffer.indexOf("\n");
						if (at < 0) break;
						let line = child.stdoutBuffer.slice(0, at);
						child.stdoutBuffer = child.stdoutBuffer.slice(at + 1);
						if (line.endsWith("\r")) line = line.slice(0, -1);
						consume(line);
					}
				});
				proc.stderr.on("data", (data: Buffer) => { child.stderr = (child.stderr + data.toString("utf8")).slice(-MAX_STDERR_BYTES); });
				proc.on("error", (error) => { setStatus(child, "error"); append(child, `[error] ${error.message}\n`); });
				proc.on("close", (code) => {
					child.exitCode = code ?? 1;
					if (child.status !== "stopped") setStatus(child, code === 0 ? "exited" : "error");
					append(child, `[${child.status}; exit ${child.exitCode}]\n`);
					for (const pending of child.pending.values()) {
						clearTimeout(pending.timer);
						pending.reject(new Error(`child exited (${child.exitCode})`));
					}
					child.pending.clear();
					if (child.tempDirectory) void fs.promises.rm(child.tempDirectory, { recursive: true, force: true });
				});

				try {
					if (signal?.aborted) throw new Error("spawn aborted");
					const state = await sendRpc(child, { type: "get_state" });
					child.model = resolvedModel(state.data) ?? child.model;
					if (child.tempDirectory) {
						await fs.promises.rm(child.tempDirectory, { recursive: true, force: true });
						child.tempDirectory = undefined;
					}
					await sendRpc(child, { type: "prompt", message: params.task.trim() });
					return { content: [{ type: "text", text: `Started ${label} (${id}) with ${child.model}. Poll for readiness.` }], details: snapshot(child) };
				} catch (error) {
					stopChild(child, "error");
					children.delete(id);
					return { content: [{ type: "text", text: `Failed to start ${label}: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
				}
			}

			if (params.action === "wait_any") {
				if (params.id) return { content: [{ type: "text", text: "wait_any does not accept id; use wait_specific." }], isError: true };
				const selectedChildren = [...children.values()];
				if (selectedChildren.length === 0) return { content: [{ type: "text", text: "No subagents." }], details: { children: [] } };
				try {
					ctx.ui.notify(`Waiting for any of ${selectedChildren.length} subagents…`, "info");
					const child = await waitWithBail(signal, (waitSignal) => Promise.race(selectedChildren.map(async (candidate) => {
						await waitForChild(candidate, waitSignal);
						return candidate;
					})));
					return { content: [{ type: "text", text: `${child.label} is ${child.status}.` }], details: snapshot(child) };
				} catch (error) {
					return { content: [{ type: "text", text: `Wait failed: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
				}
			}

			if (!params.id) return { content: [{ type: "text", text: `${params.action} requires id` }], isError: true };
			const child = findChild(params.id);
			if (!child) return { content: [{ type: "text", text: `Unknown subagent: ${params.id}` }], isError: true };

			if (params.action === "wait_specific") {
				try {
					ctx.ui.notify(`Waiting for subagent ${child.label}…`, "info");
					await waitWithBail(signal, (waitSignal) => waitForChild(child, waitSignal));
					return { content: [{ type: "text", text: `${child.label} is ${child.status}.` }], details: snapshot(child) };
				} catch (error) {
					return { content: [{ type: "text", text: `Wait failed: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
				}
			}
			if (params.action === "stop") {
				stopChild(child);
				children.delete(child.id);
				return { content: [{ type: "text", text: `Stopped ${child.label} (${child.id}).` }], details: { id: child.id, status: child.status } };
			}
			if (params.action === "send") {
				if (!params.task?.trim()) return { content: [{ type: "text", text: "send requires task" }], isError: true };
				try {
					await sendRpc(child, { type: "prompt", message: params.task.trim(), ...(child.status === "running" ? { streamingBehavior: "followUp" } : {}) });
					child.prompts.push({ at: Date.now(), text: params.task.trim() });
					return { content: [{ type: "text", text: `Sent to ${child.label} (${child.id}). Poll for readiness.` }], details: snapshot(child) };
				} catch (error) {
					return { content: [{ type: "text", text: `Send failed: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
				}
			}

			const requested = params.cursor ?? Math.max(child.inspectionCursor, child.baseCursor);
			const cursor = Math.min(Math.max(requested, child.baseCursor), child.nextCursor);
			const maxBytes = params.maxBytes ?? DEFAULT_INSPECT_BYTES;
			const start = cursor - child.baseCursor;
			const chunk = child.buffer.subarray(start, Math.min(start + maxBytes, child.buffer.length));
			const nextCursor = cursor + chunk.length;
			child.inspectionCursor = Math.max(child.inspectionCursor, nextCursor);
			const lost = requested < child.baseCursor;
			const header = lost ? `[Earlier output expired; resumed at ${child.baseCursor}.]\n` : "";
			const text = header + chunk.toString("utf8") || "(no new output)";
			return {
				content: [{ type: "text", text }],
				details: { ...snapshot(child), cursor: nextCursor, more: nextCursor < child.nextCursor, retainedFrom: child.baseCursor, lost },
			};
		},
	});
}
