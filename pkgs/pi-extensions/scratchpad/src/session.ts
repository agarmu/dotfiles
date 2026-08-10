import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { randomUUID } from "node:crypto";

let generatedSessionId: string | undefined;

function safeSessionId(): string {
  const explicit = process.env.PI_SESSION_ID?.trim();
  if (explicit && /^[A-Za-z0-9][A-Za-z0-9._-]*$/.test(explicit)) return explicit;
  const fromFile = process.env.PI_SESSION_FILE?.split(path.sep).pop()?.replace(/\.jsonl$/, "");
  if (fromFile && /^[A-Za-z0-9][A-Za-z0-9._-]*$/.test(fromFile)) return fromFile;
  generatedSessionId ??= randomUUID();
  return generatedSessionId;
}

export function piHome(): string {
  return process.env.PI_HOME?.trim() || process.env.PI_CODING_AGENT_DIR?.trim() || path.join(os.homedir(), ".pi");
}

export function scratchpadRoot(): string {
  return path.join(piHome(), "scratchpad");
}

function piAgentDir(): string {
  return process.env.PI_CODING_AGENT_DIR?.trim() || path.join(os.homedir(), ".pi", "agent");
}

export function scratchpadPath(): string {
  return path.join(scratchpadRoot(), safeSessionId());
}

export async function ensureScratchpad(): Promise<string> {
  const directory = scratchpadPath();
  await fs.promises.mkdir(directory, { recursive: true, mode: 0o700 });
  await fs.promises.chmod(directory, 0o700);
  return directory;
}

export async function configureSandbox(): Promise<void> {
  if (process.env.PI_SCRATCHPAD_SANDBOX === "0") return;
  const configPath = path.join(piAgentDir(), "sandbox.json");
  const config = await readSandboxConfig(configPath);
  if (!config) return;

  const filesystem = objectValue(config.filesystem);
  const root = scratchpadRoot();
  // Preserve Pi Sandbox v0.6.2 defaults when initializing its global config.
  const allowRead = stringArray(filesystem.allowRead, [".", "~/.config", "~/.local", "Library"]);
  const allowWrite = stringArray(filesystem.allowWrite, [".", "/tmp"]);
  if (allowRead.includes(root) && allowWrite.includes(root)) return;

  filesystem.allowRead = addPath(allowRead, root);
  filesystem.allowWrite = addPath(allowWrite, root);
  config.filesystem = filesystem;
  await writeSandboxConfig(configPath, config);
}

async function readSandboxConfig(configPath: string): Promise<Record<string, unknown> | undefined> {
  try {
    const parsed: unknown = JSON.parse(await fs.promises.readFile(configPath, "utf8"));
    return parsed && typeof parsed === "object" && !Array.isArray(parsed) ? parsed as Record<string, unknown> : undefined;
  } catch (error) {
    return (error as NodeJS.ErrnoException).code === "ENOENT" ? {} : undefined;
  }
}

function objectValue(value: unknown): Record<string, unknown> {
  return value && typeof value === "object" && !Array.isArray(value) ? value as Record<string, unknown> : {};
}

function stringArray(value: unknown, fallback: string[]): string[] {
  return Array.isArray(value) && value.every((entry) => typeof entry === "string") ? value : fallback;
}

function addPath(paths: string[], target: string): string[] {
  return paths.includes(target) ? paths : [...paths, target];
}

async function writeSandboxConfig(configPath: string, config: Record<string, unknown>): Promise<void> {
  await fs.promises.mkdir(path.dirname(configPath), { recursive: true });
  const temporaryPath = `${configPath}.${process.pid}.tmp`;
  await fs.promises.writeFile(temporaryPath, `${JSON.stringify(config, null, 2)}\n`, { mode: 0o600 });
  await fs.promises.rename(temporaryPath, configPath);
}
