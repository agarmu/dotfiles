import { spawn } from "node:child_process";
import { createHash, randomUUID } from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";
import { safeFilename } from "./model.ts";

const MAX_CORPUS_BYTES = 20 * 1024 * 1024;
const PDF_TO_TEXT = "@PDFTOTEXT@";
const TAR = "@TAR@";

export type PreparedCorpus = { path: string; lines: number; bytes: number };
export type ExtractedRange = { text: string; start: number; end: number; requestedEnd: number; truncated: boolean; partialLine: boolean; nextStart?: number };

export async function preparePaperCorpus(inputPath: string, scratchpad: string): Promise<PreparedCorpus> {
  const source = await validateSource(inputPath, scratchpad);
  const corpusPath = await destinationFor(source.path, source.stat, scratchpad);
  if (!await isRegularFile(corpusPath)) await createCorpus(source.path, source.stat, corpusPath);
  return corpusMetadata(corpusPath);
}

export async function extractCorpusRange(corpusPath: string, scratchpad: string, start: number, end: number, maxChars: number): Promise<ExtractedRange> {
  if (end < start) throw new Error("end must be greater than or equal to start");
  const resolvedPath = await validateCorpusPath(corpusPath, scratchpad);
  const lines = (await fs.promises.readFile(resolvedPath, "utf8")).split(/\r?\n/);
  if (start > lines.length) throw new Error(`start exceeds the corpus length (${lines.length} lines)`);
  return selectLines(lines, start, Math.min(end, lines.length), maxChars);
}

function selectLines(lines: string[], start: number, requestedEnd: number, maxChars: number): ExtractedRange {
  const selected: string[] = [];
  let characters = 0;
  let actualEnd = start - 1;
  let partialLine = false;
  for (let line = start; line <= requestedEnd; line += 1) {
    const value = `${lines[line - 1]}\n`;
    if (characters + value.length > maxChars) {
      if (!selected.length) {
        selected.push(value.slice(0, maxChars));
        actualEnd = line;
        partialLine = true;
      }
      break;
    }
    selected.push(value);
    characters += value.length;
    actualEnd = line;
  }
  const truncated = partialLine || actualEnd < requestedEnd;
  return { text: selected.join(""), start, end: actualEnd, requestedEnd, truncated, partialLine, nextStart: !partialLine && truncated ? actualEnd + 1 : undefined };
}

async function validateSource(inputPath: string, scratchpad: string): Promise<{ path: string; stat: fs.Stats }> {
  const scratchpadReal = await fs.promises.realpath(scratchpad);
  const source = await fs.promises.realpath(inputPath);
  if (!isWithin(scratchpadReal, source)) throw new Error("Paper input must be inside the current session scratchpad");
  const stat = await fs.promises.stat(source);
  if (!stat.isFile()) throw new Error("Paper input must be a regular file");
  if (stat.size > 110 * 1024 * 1024) throw new Error("Paper input exceeds 110 MiB");
  return { path: source, stat };
}

async function validateCorpusPath(inputPath: string, scratchpad: string): Promise<string> {
  const corpusRoot = await fs.promises.realpath(path.join(scratchpad, "papers", "corpora"));
  const corpusPath = await fs.promises.realpath(inputPath);
  if (!isWithin(corpusRoot, corpusPath)) throw new Error("extract only accepts a corpus produced by paper_read prepare");
  return corpusPath;
}

async function destinationFor(source: string, stat: fs.Stats, scratchpad: string): Promise<string> {
  const corpusDirectory = path.join(await fs.promises.realpath(scratchpad), "papers", "corpora");
  await fs.promises.mkdir(corpusDirectory, { recursive: true, mode: 0o700 });
  const signature = createHash("sha256").update(`${source}\0${stat.size}\0${stat.mtimeMs}`).digest("hex").slice(0, 16);
  return path.join(corpusDirectory, `${safeFilename(path.basename(source))}-${signature}.txt`);
}

async function createCorpus(source: string, stat: fs.Stats, corpusPath: string): Promise<void> {
  const temporaryPath = `${corpusPath}.${process.pid}.${randomUUID()}.tmp`;
  try {
    await convertSource(source, stat, temporaryPath);
    await validatePreparedSize(temporaryPath);
    await fs.promises.chmod(temporaryPath, 0o600);
    await fs.promises.rename(temporaryPath, corpusPath);
  } catch (error) {
    await fs.promises.unlink(temporaryPath).catch(() => undefined);
    throw error;
  }
}

async function convertSource(source: string, stat: fs.Stats, destination: string): Promise<void> {
  const lower = source.toLowerCase();
  if (lower.endsWith(".pdf")) return runProcess(PDF_TO_TEXT, ["-layout", "-enc", "UTF-8", source, destination]);
  if (lower.endsWith(".tar") || lower.endsWith(".tar.gz") || lower.endsWith(".tgz")) return convertArchive(source, destination);
  if (/\.(?:tex|txt|md)$/i.test(lower)) return copyText(source, stat, destination);
  throw new Error("Supported paper inputs are PDF, TeX, text, Markdown, and tar/tar.gz source archives");
}

async function copyText(source: string, stat: fs.Stats, destination: string): Promise<void> {
  if (stat.size > MAX_CORPUS_BYTES) throw new Error("Text corpus exceeds 20 MiB");
  await fs.promises.copyFile(source, destination);
}

async function convertArchive(source: string, destination: string): Promise<void> {
  const entries = (await runCapture(TAR, ["-tf", source], 2 * 1024 * 1024)).split(/\r?\n/).filter(Boolean);
  const texFiles = entries.filter(isSafeTexEntry).sort().slice(0, 500);
  if (!texFiles.length) throw new Error("The source archive contains no safe TeX files");
  const chunks = await readTexEntries(source, texFiles);
  await fs.promises.writeFile(destination, chunks.join(""), { encoding: "utf8", mode: 0o600 });
}

function isSafeTexEntry(entry: string): boolean {
  return entry.toLowerCase().endsWith(".tex") && !path.isAbsolute(entry) && !entry.split("/").includes("..");
}

async function readTexEntries(source: string, entries: string[]): Promise<string[]> {
  const chunks: string[] = [];
  let bytes = 0;
  for (const entry of entries) {
    const content = await runCapture(TAR, ["-xOf", source, "--", entry], MAX_CORPUS_BYTES);
    const chunk = `\n% ===== FILE: ${entry} =====\n${content}\n`;
    bytes += Buffer.byteLength(chunk);
    if (bytes > MAX_CORPUS_BYTES) throw new Error("Prepared TeX corpus exceeds 20 MiB");
    chunks.push(chunk);
  }
  return chunks;
}

async function validatePreparedSize(pathname: string): Promise<void> {
  if ((await fs.promises.stat(pathname)).size > MAX_CORPUS_BYTES) throw new Error("Prepared corpus exceeds 20 MiB");
}

async function corpusMetadata(pathname: string): Promise<PreparedCorpus> {
  const corpus = await fs.promises.readFile(pathname, "utf8");
  return { path: pathname, lines: corpus.split(/\r?\n/).length, bytes: Buffer.byteLength(corpus) };
}

async function isRegularFile(pathname: string): Promise<boolean> {
  return fs.promises.stat(pathname).then((stat) => stat.isFile()).catch(() => false);
}

function isWithin(root: string, candidate: string): boolean {
  const relative = path.relative(root, candidate);
  return relative === "" || (relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative));
}

async function runCapture(command: string, args: string[], maxBytes: number): Promise<string> {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { shell: false, stdio: ["ignore", "pipe", "pipe"] });
    const stdout: Buffer[] = [];
    let bytes = 0;
    let stderr = "";
    let overflow = false;
    child.stdout.on("data", (chunk: Buffer) => {
      bytes += chunk.length;
      if (bytes > maxBytes) { overflow = true; child.kill("SIGTERM"); } else stdout.push(chunk);
    });
    child.stderr.on("data", (chunk: Buffer) => { stderr = boundedStderr(stderr, chunk); });
    child.on("error", reject);
    child.on("close", (code) => finishProcess(code, stderr, overflow ? `Command output exceeded ${maxBytes} bytes` : undefined, () => resolve(Buffer.concat(stdout).toString("utf8")), reject));
  });
}

async function runProcess(command: string, args: string[]): Promise<void> {
  await new Promise<void>((resolve, reject) => {
    const child = spawn(command, args, { shell: false, stdio: ["ignore", "ignore", "pipe"] });
    let stderr = "";
    child.stderr.on("data", (chunk: Buffer) => { stderr = boundedStderr(stderr, chunk); });
    child.on("error", reject);
    child.on("close", (code) => finishProcess(code, stderr, undefined, resolve, reject));
  });
}

function finishProcess(code: number | null, stderr: string, forcedError: string | undefined, resolve: () => void, reject: (error: Error) => void): void {
  if (forcedError) reject(new Error(forcedError));
  else if (code !== 0) reject(new Error(stderr.trim() || `Command exited ${code ?? 1}`));
  else resolve();
}

function boundedStderr(current: string, chunk: Buffer): string {
  return (current + chunk.toString("utf8")).slice(-8192);
}
