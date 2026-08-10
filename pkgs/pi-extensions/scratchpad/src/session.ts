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

export function scratchpadPath(): string {
  return path.join(scratchpadRoot(), safeSessionId());
}

export async function ensureScratchpad(): Promise<string> {
  const directory = scratchpadPath();
  await fs.promises.mkdir(directory, { recursive: true, mode: 0o700 });
  await fs.promises.chmod(directory, 0o700);
  return directory;
}

export async function configureGuardrails(): Promise<void> {
  if (process.env.PI_SCRATCHPAD_GUARDRAILS === "0") return;
  const configPath = path.join(piHome(), "extensions", "guardrails.json");
  const config = await readGuardrailsConfig(configPath);
  if (!config) return;
  const pathAccess = objectValue(config.pathAccess);
  const allowedPaths = Array.isArray(pathAccess.allowedPaths) ? pathAccess.allowedPaths : [];
  const exists = allowedPaths.some((entry) => isScratchpadPermission(entry));
  if (exists) return;
  pathAccess.allowedPaths = [...allowedPaths, { kind: "directory", path: scratchpadRoot() }];
  config.pathAccess = pathAccess;
  await writeGuardrailsConfig(configPath, config);
}

async function readGuardrailsConfig(configPath: string): Promise<Record<string, unknown> | undefined> {
  try {
    return JSON.parse(await fs.promises.readFile(configPath, "utf8")) as Record<string, unknown>;
  } catch (error) {
    return (error as NodeJS.ErrnoException).code === "ENOENT" ? {} : undefined;
  }
}

function objectValue(value: unknown): Record<string, unknown> {
  return value && typeof value === "object" ? value as Record<string, unknown> : {};
}

function isScratchpadPermission(entry: unknown): boolean {
  const value = objectValue(entry);
  return value.kind === "directory" && value.path === scratchpadRoot();
}

async function writeGuardrailsConfig(configPath: string, config: Record<string, unknown>): Promise<void> {
  await fs.promises.mkdir(path.dirname(configPath), { recursive: true });
  const temporaryPath = `${configPath}.${process.pid}.tmp`;
  await fs.promises.writeFile(temporaryPath, `${JSON.stringify(config, null, 2)}\n`, { mode: 0o600 });
  await fs.promises.rename(temporaryPath, configPath);
}
