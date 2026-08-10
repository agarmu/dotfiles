import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { randomUUID } from "node:crypto";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

let generatedSessionId: string | undefined;

function safeSessionId(): string {
  const value = process.env.PI_SESSION_ID?.trim();
  if (value && /^[A-Za-z0-9][A-Za-z0-9._-]*$/.test(value)) return value;
  const fromFile = process.env.PI_SESSION_FILE?.split(path.sep).pop()?.replace(/\.jsonl$/, "");
  if (fromFile && /^[A-Za-z0-9][A-Za-z0-9._-]*$/.test(fromFile)) return fromFile;
  generatedSessionId ??= randomUUID();
  return generatedSessionId;
}

function piHome(): string {
  // PI_HOME is intentionally supported for users who keep Pi data elsewhere.
  return process.env.PI_HOME?.trim() || process.env.PI_CODING_AGENT_DIR?.trim() || path.join(os.homedir(), ".pi");
}

function scratchpadRoot(): string {
  return path.join(piHome(), "scratchpad");
}

function scratchpadPath(): string {
  return path.join(scratchpadRoot(), safeSessionId());
}

async function configureGuardrails(): Promise<void> {
  if (process.env.PI_SCRATCHPAD_GUARDRAILS === "0") return;

  const configPath = path.join(piHome(), "extensions", "guardrails.json");
  let config: Record<string, unknown> = {};
  try {
    config = JSON.parse(await fs.promises.readFile(configPath, "utf8")) as Record<string, unknown>;
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code !== "ENOENT") return;
  }

  const pathAccess = (config.pathAccess && typeof config.pathAccess === "object")
    ? config.pathAccess as Record<string, unknown>
    : {};
  const allowedPaths = Array.isArray(pathAccess.allowedPaths) ? pathAccess.allowedPaths : [];
  const alreadyAllowed = allowedPaths.some((entry) => entry && typeof entry === "object" && (entry as { kind?: unknown }).kind === "directory" && (entry as { path?: unknown }).path === scratchpadRoot());
  if (alreadyAllowed) return;

  pathAccess.allowedPaths = [...allowedPaths, { kind: "directory", path: scratchpadRoot() }];
  config.pathAccess = pathAccess;
  await fs.promises.mkdir(path.dirname(configPath), { recursive: true });
  const temporaryPath = `${configPath}.${process.pid}.tmp`;
  await fs.promises.writeFile(temporaryPath, `${JSON.stringify(config, null, 2)}\n`, { mode: 0o600 });
  await fs.promises.rename(temporaryPath, configPath);
}

async function ensureScratchpad(): Promise<string> {
  const directory = scratchpadPath();
  await fs.promises.mkdir(directory, { recursive: true, mode: 0o700 });
  await fs.promises.chmod(directory, 0o700);
  return directory;
}

const Parameters = Type.Object({
	action: Type.Optional(Type.Union([Type.Literal("path"), Type.Literal("list")])),
});

const PaperSearchParameters = Type.Object({
	query: Type.String({ description: "Free-text or provider-aware query. arXiv syntax such as ti:\"quantum gravity\" AND au:Einstein is supported; quoted phrases and AND/OR are passed through." }),
	author: Type.Optional(Type.String({ description: "Author name, ORCID, or OpenAlex author id." })),
	yearFrom: Type.Optional(Type.Integer({ minimum: 1000, description: "Earliest publication year (inclusive)." })),
	yearTo: Type.Optional(Type.Integer({ minimum: 1000, description: "Latest publication year (inclusive)." })),
	openAccess: Type.Optional(Type.Boolean({ description: "Only return records marked open access where the provider supports this filter." })),
	source: Type.Optional(Type.Union([
		Type.Literal("all"), Type.Literal("openalex"), Type.Literal("arxiv"), Type.Literal("crossref"),
	])),
	maxResults: Type.Optional(Type.Integer({ minimum: 1, maximum: 10, description: "Maximum results per source (default 3)." })),
	includeAbstract: Type.Optional(Type.Boolean({ description: "Include abstracts; default false to keep results compact." })),
	includeVerificationFailures: Type.Optional(Type.Boolean({ description: "Only when needed: include candidates rejected by local query verification." })),
});

const PaperDownloadParameters = Type.Object({
	url: Type.Optional(Type.String({ description: "Direct PDF or source URL." })),
	arxivId: Type.Optional(Type.String({ description: "arXiv identifier, e.g. 2301.01234 or 2301.01234v2." })),
	format: Type.Optional(Type.Union([Type.Literal("pdf"), Type.Literal("source")])),
	filename: Type.Optional(Type.String({ description: "Optional output filename." })),
});

type Paper = { title: string; authors: string[]; authorIds?: string[]; year?: number; venue?: string; doi?: string; abstract?: string; urls: string[]; source: string; id?: string };

const text = (value: unknown): string => typeof value === "string" ? value : "";

function parsePaperQuery(query: string): { positive: string; arxiv: string; exclusions: string[] } {
  const exclusions: string[] = [];
  let positive = query;
  const collect = (value: string) => { const term = value.trim().replace(/^['"]|['"]$/g, ""); if (term) exclusions.push(term); };
  positive = positive.replace(/!\s*\(([^()]*)\)/g, (_match, term: string) => { collect(term); return " "; });
  positive = positive.replace(/!\s*(?:"([^"]+)"|'([^']+)'|(\S+))/g, (_match, doubleQuoted: string, singleQuoted: string, bare: string) => { collect(doubleQuoted || singleQuoted || bare); return " "; });
  positive = positive.replace(/\bNOT\s+(?:"([^"]+)"|'([^']+)'|(\S+))/gi, (_match, doubleQuoted: string, singleQuoted: string, bare: string) => { collect(doubleQuoted || singleQuoted || bare); return " "; });
  const arxiv = positive
    .replace(/\s*&\s*/g, " AND ")
    .replace(/\s*\|\s*/g, " OR ")
    .replace(/\s+/g, " ")
    .replace(/^(?:(?:AND|OR|ANDNOT)\s+)+/i, "")
    .replace(/(?:\s+(?:AND|OR|ANDNOT))+$/i, "")
    .replace(/\b(AND|OR|ANDNOT)(?:\s+\1\b)+/gi, "$1")
    .trim();
  return { positive: arxiv, arxiv, exclusions };
}

function excludesPaper(paper: Paper, exclusions: string[]): boolean {
  const haystack = [paper.title, ...paper.authors, paper.abstract, paper.venue].filter(Boolean).join(" ").toLowerCase();
  return exclusions.some((term) => haystack.includes(term.toLowerCase()));
}

function matchesPositiveQuery(paper: Paper, query: string): boolean {
  if (!query.trim()) return true;
  const haystack = [paper.title, ...paper.authors, paper.abstract, paper.venue, paper.doi].filter(Boolean).join(" ").toLowerCase();
  const clauses = query.replace(/[()]/g, " ").split(/\s+(?:OR|\|)\s+/i);
  return clauses.some((clause) => {
    const terms = [...clause.matchAll(/(?:[a-z]+:)?(?:"([^"]+)"|'([^']+)'|([^\s&|]+))/gi)]
      .map((match) => (match[1] || match[2] || match[3]).toLowerCase())
      .filter((term) => term && !/^(?:and|or|andnot|not)$/.test(term));
    return terms.every((term) => haystack.includes(term));
  });
}

function normalizedAuthorId(value: string): string {
  return value.trim().toLowerCase().replace(/^https?:\/\/(?:www\.)?openalex\.org\//, "").replace(/^https?:\/\/(?:www\.)?orcid\.org\//, "");
}

function authorIdentifier(author?: string): { kind: "openalex" | "orcid"; value: string } | undefined {
  if (!author?.trim()) return undefined;
  const value = normalizedAuthorId(author);
  if (/^a\d+$/i.test(value)) return { kind: "openalex", value };
  if (/^\d{4}-\d{4}-\d{4}-[\dX]{4}$/i.test(value)) return { kind: "orcid", value };
  return undefined;
}

function matchesAuthor(paper: Paper, author?: string): boolean {
  if (!author?.trim()) return true;
  const identifier = authorIdentifier(author);
  if (identifier) return (paper.authorIds || []).some((value) => normalizedAuthorId(value) === identifier.value);
  const haystack = paper.authors.join(" ").toLowerCase();
  return author.toLowerCase().split(/\s+/).filter(Boolean).every((term) => haystack.includes(term));
}

function paperIdentifier(paper: Paper): string {
  if (paper.source === "arXiv" && paper.id) return `arXiv:${paper.id}`;
  if (paper.doi) return `doi:${paper.doi}`;
  return paper.id || `${paper.source}:${safeFilename(paper.title).slice(0, 60)}`;
}

async function getJson(url: string): Promise<unknown> {
	const response = await fetch(url, { headers: { accept: "application/json", "user-agent": "pi-scratchpad/0.2.0 (academic paper search)" } });
	if (!response.ok) throw new Error(`${response.status} ${response.statusText}`);
	return response.json();
}

function openAlexPapers(data: any): Paper[] {
	return (data.results || []).map((item: any): Paper => ({
		title: text(item.title), authors: (item.authorships || []).map((a: any) => text(a.author?.display_name)).filter(Boolean),
		authorIds: (item.authorships || []).flatMap((a: any) => [a.author?.id, a.author?.orcid]).filter((value: unknown): value is string => typeof value === "string"),
		year: item.publication_year, venue: text(item.primary_location?.source?.display_name), doi: text(item.doi).replace(/^https?:\/\/doi.org\//, ""),
		abstract: item.abstract_inverted_index ? Object.entries(item.abstract_inverted_index).flatMap(([word, positions]) => (positions as number[]).map((position) => [position, word] as [number, string])).sort((a, b) => a[0] - b[0]).map(([, word]) => word).join(" ") : undefined,
		urls: [item.best_oa_location?.pdf_url, item.open_access?.oa_url, item.primary_location?.landing_page_url, item.doi].filter((url): url is string => Boolean(url)), source: "OpenAlex", id: text(item.id),
	}));
}

function xmlValue(entry: string, tag: string): string {
	const match = entry.match(new RegExp(`<${tag}(?:\\s[^>]*)?>([\\s\\S]*?)</${tag}>`));
	return match ? match[1].replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").replace(/<[^>]+>/g, "").replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").trim() : "";
}

function arxivPapers(xml: string): Paper[] {
	return [...xml.matchAll(/<entry>([\s\S]*?)<\/entry>/g)].map(([, entry]): Paper => ({
		title: xmlValue(entry, "title"), authors: [...entry.matchAll(/<author>[\s\S]*?<name>([\s\S]*?)<\/name>[\s\S]*?<\/author>/g)].map(([, name]) => name.trim()), year: Number(xmlValue(entry, "published").slice(0, 4)) || undefined,
		abstract: xmlValue(entry, "summary"), urls: [`https://arxiv.org/abs/${xmlValue(entry, "id").split("/abs/").pop() || ""}`, `https://arxiv.org/pdf/${xmlValue(entry, "id").split("/abs/").pop() || ""}.pdf`], source: "arXiv", id: xmlValue(entry, "id").split("/abs/").pop(),
	}));
}

function crossrefPapers(data: any): Paper[] {
	return (data.message?.items || []).map((item: any): Paper => ({
		title: text(item.title?.[0]), authors: (item.author || []).map((a: any) => [a.given, a.family].filter(Boolean).join(" ")), authorIds: (item.author || []).map((a: any) => a.ORCID).filter((value: unknown): value is string => typeof value === "string"), year: item.published?.["date-parts"]?.[0]?.[0], venue: text(item["container-title"]?.[0]), doi: text(item.DOI), urls: [item.URL, ...(item.link || []).map((link: any) => link.URL)].filter((url): url is string => Boolean(url)), source: "Crossref",
	}));
}

function safeFilename(name: string): string {
	const value = name.replace(/[^A-Za-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 160);
	return value || `paper-${Date.now()}`;
}

async function downloadFile(url: string, destination: string): Promise<number> {
	let current = new URL(url);
	for (let redirect = 0; redirect < 5; redirect += 1) {
		if (!/^https?:$/.test(current.protocol)) throw new Error("Only HTTP(S) paper URLs are supported");
		const response = await fetch(current, { redirect: "manual", headers: { "user-agent": "pi-scratchpad/0.2.0 (paper download)" } });
		if (response.status >= 300 && response.status < 400) {
			const location = response.headers.get("location");
			if (!location) throw new Error("Download redirect had no location");
			current = new URL(location, current);
			continue;
		}
		if (!response.ok || !response.body) throw new Error(`${response.status} ${response.statusText}`);
		const length = Number(response.headers.get("content-length") || 0);
		if (length > 100 * 1024 * 1024) throw new Error("Refusing downloads larger than 100 MiB");
		const file = await fs.promises.open(destination, "w", 0o600);
		let bytes = 0;
		try { for await (const chunk of response.body as any) { bytes += chunk.length; if (bytes > 100 * 1024 * 1024) throw new Error("Download exceeded 100 MiB"); await file.write(chunk); } } finally { await file.close(); }
		return bytes;
	}
	throw new Error("Too many download redirects");
}

export default async function registerScratchpad(pi: ExtensionAPI) {
  await configureGuardrails();
  let directory = scratchpadPath();

  pi.on("session_start", async (_event, ctx) => {
    directory = await ensureScratchpad();
    ctx.ui.notify(`Scratchpad: ${directory}`, "info");
  });

  pi.on("before_agent_start", async (event) => {
    directory = await ensureScratchpad();
    return {
      systemPrompt: `${event.systemPrompt}\n\n## Session scratchpad\nA private, persistent scratchpad is available at \`${directory}\`. Use it for temporary files, cloned repositories, experiments, and other work that should not be placed in the current project. Run commands there with \`cd ${directory}\` (or use absolute paths). It is unique to this Pi session. Use paper_search to find academic papers in OpenAlex, arXiv, and Crossref, then paper_download to save an available PDF or arXiv source archive under \`${path.join(directory, "papers")}\`.`,
    };
  });

  pi.registerTool({
    name: "paper_search",
    label: "Academic Papers",
    description: "Search academic paper metadata across OpenAlex, arXiv, and Crossref by topic, title, DOI, and/or author. Results include open-access and arXiv download URLs when available.",
    promptSnippet: "Search papers with a plain-language query and optional author/year filters",
    promptGuidelines: [
      "Use a short natural-language query plus author, yearFrom, yearTo, or openAccess when those constraints are known.",
      "For exclusions, use simple syntax like `transformers & !(vision)`; ordinary words and these Boolean operators are translated automatically.",
      "Do not write provider-specific field syntax unless a simple query is ambiguous; paper_search translates ordinary queries for all providers.",
      "Keep the first search compact; set includeAbstract only when the user asks for abstracts or more detail about the shortlisted papers.",
      "Use paper_download with an arxivId or a result URL when the user asks for the paper contents or source.",
    ],
    parameters: PaperSearchParameters,
    async execute(_toolCallId, params) {
      const query = params.query.trim();
      if (!query) return { content: [{ type: "text", text: "query is required" }], isError: true };
      const parsedQuery = parsePaperQuery(query);
      const limit = params.maxResults || 3;
      const source = params.source || "all";
      const author = params.author?.trim();
      const authorId = authorIdentifier(author);
      const jobs: Promise<Paper[]>[] = [];
      if (source === "all" || source === "openalex") {
        const filters = [
          params.yearFrom ? `from_publication_date:${params.yearFrom}-01-01` : "",
          params.yearTo ? `to_publication_date:${params.yearTo}-12-31` : "",
          params.openAccess ? "is_oa:true" : "",
          authorId?.kind === "openalex" ? `authorships.author.id:${authorId.value}` : "",
          authorId?.kind === "orcid" ? `authorships.author.orcid:https://orcid.org/${authorId.value}` : "",
        ].filter(Boolean).join(",");
        const filterParam = filters ? `&filter=${encodeURIComponent(filters)}` : "";
        const search = [parsedQuery.positive, authorId ? "" : author].filter(Boolean).join(" ");
        jobs.push(getJson(`https://api.openalex.org/works?${search ? `search=${encodeURIComponent(search)}&` : ""}per-page=${limit}${filterParam}`).then(openAlexPapers));
      }
      if (source === "all" || source === "arxiv") {
        const structured = /(?:^|\s)(?:ti|au|abs|cat|co|jr|rn|id|submittedDate):/i.test(parsedQuery.arxiv) || /\b(?:AND|OR|ANDNOT)\b/i.test(parsedQuery.arxiv);
        const dateRange = params.yearFrom || params.yearTo ? `submittedDate:[${params.yearFrom || 1000}01010000 TO ${params.yearTo || 9999}12312359]` : "";
        const negative = parsedQuery.exclusions.map((term) => `all:"${term.replaceAll('"', '\\"')}"`).join(" ANDNOT ");
        const positive = parsedQuery.arxiv ? (structured ? parsedQuery.arxiv : `all:${parsedQuery.arxiv}`) : "all:*";
        const q = `${[positive, author && !authorId && !/\bau:/i.test(parsedQuery.arxiv) ? `au:${author}` : "", dateRange].filter(Boolean).join(" AND ")}${negative ? ` ANDNOT ${negative}` : ""}`;
        jobs.push(fetch(`https://export.arxiv.org/api/query?search_query=${encodeURIComponent(q)}&start=0&max_results=${limit}`, { headers: { "user-agent": "pi-scratchpad/0.2.0 (academic paper search)" } }).then(async (response) => { if (!response.ok) throw new Error(`${response.status} ${response.statusText}`); return arxivPapers(await response.text()); }));
      }
      if (source === "all" || source === "crossref") {
        const filters = [params.yearFrom ? `from-pub-date:${params.yearFrom}-01-01` : "", params.yearTo ? `until-pub-date:${params.yearTo}-12-31` : "", authorId?.kind === "orcid" ? `orcid:${authorId.value}` : ""].filter(Boolean).join(",");
        const filterParam = filters ? `&filter=${encodeURIComponent(filters)}` : "";
        const search = parsedQuery.positive ? `query.bibliographic=${encodeURIComponent(parsedQuery.positive)}&` : "";
        const url = `https://api.crossref.org/works?${search}${author && !authorId ? `query.author=${encodeURIComponent(author)}&` : ""}rows=${limit}${filterParam}`;
        jobs.push(getJson(url).then(crossrefPapers));
      }
      const results = await Promise.allSettled(jobs);
      const fetchedPapers = results.flatMap((result) => result.status === "fulfilled" ? result.value : []);
      const papers = fetchedPapers.filter((paper) => matchesPositiveQuery(paper, parsedQuery.positive) && matchesAuthor(paper, author) && !excludesPaper(paper, parsedQuery.exclusions));
      const verificationFailures = fetchedPapers.filter((paper) => !papers.includes(paper));
      const failures = results.filter((result): result is PromiseRejectedResult => result.status === "rejected").map((result) => result.reason instanceof Error ? result.reason.message : String(result.reason));
      const lines = papers.map((paper, index) => `${index + 1}. ${paperIdentifier(paper)} — ${paper.title || "(untitled)"}\n   ${paper.authors.slice(0, 3).join(", ") || "unknown authors"}${paper.authors.length > 3 ? " et al." : ""}${paper.year ? ` · ${paper.year}` : ""}${paper.venue ? ` · ${paper.venue}` : ""}${paper.urls[0] ? `\n   Link: ${paper.urls[0]}` : ""}${params.includeAbstract && paper.abstract ? `\n   Abstract: ${paper.abstract}` : ""}`);
      const failedLines = params.includeVerificationFailures ? verificationFailures.map((paper, index) => `${index + 1}. ${paperIdentifier(paper)} — ${paper.title || "(untitled)"}\n   ${paper.authors.slice(0, 3).join(", ") || "unknown authors"}${paper.year ? ` · ${paper.year}` : ""}${paper.urls[0] ? `\n   Link: ${paper.urls[0]}` : ""}`) : [];
      const scholar = `https://scholar.google.com/scholar?q=${encodeURIComponent([query, author].filter(Boolean).join(" "))}`;
      const compactResults = papers.map((paper) => ({ identifier: paperIdentifier(paper), title: paper.title, authors: paper.authors.slice(0, 3), year: paper.year, venue: paper.venue, doi: paper.doi, urls: paper.urls.slice(0, 1), ...(params.includeAbstract ? { abstract: paper.abstract } : {}) }));
      const verificationNote = verificationFailures.length ? `\n\n${verificationFailures.length} candidate(s) failed local query verification and are hidden. Set includeVerificationFailures=true to inspect them.` : "";
      const failedSection = failedLines.length ? `\n\nVerification-failed candidates (explicitly requested):\n${failedLines.join("\n\n")}` : "";
      return { content: [{ type: "text", text: `${lines.join("\n\n") || "No verified papers found."}${verificationNote}${failedSection}${failures.length ? `\n\nUnavailable sources: ${failures.join("; ")}` : ""}\n\nGoogle Scholar discovery: ${scholar}` }], details: { results: compactResults, unavailableSources: failures, verification: { checked: fetchedPapers.length, rejected: verificationFailures.length, rejectedResultsIncluded: Boolean(params.includeVerificationFailures) }, googleScholarUrl: scholar } };
    },
  });

  pi.registerTool({
    name: "paper_download",
    label: "Download Paper",
    description: "Download a paper PDF or arXiv source archive into the current session scratchpad/papers directory. Provide either url or arxivId.",
    promptSnippet: "Download an available paper PDF or arXiv source archive into the session scratchpad",
    promptGuidelines: [
      "Prefer arxivId for arXiv papers; use format `source` when TeX, figures, or supplementary files are requested.",
      "If the download fails, tell the user the URL and that they can download it in a browser and place the file in the reported scratchpad/papers directory.",
    ],
    parameters: PaperDownloadParameters,
    async execute(_toolCallId, params) {
      if (!params.url && !params.arxivId) return { content: [{ type: "text", text: "Provide url or arxivId" }], isError: true };
      const format = params.format || "pdf";
      const arxivId = params.arxivId?.trim().replace(/^https?:\/\/(?:export\.)?arxiv\.org\/(?:abs|pdf|e-print)\//, "").replace(/\.pdf$/, "");
      const url = params.url?.trim() || `https://export.arxiv.org/${format === "source" ? "e-print" : "pdf"}/${arxivId}${format === "pdf" ? ".pdf" : ""}`;
      const targetDirectory = path.join(await ensureScratchpad(), "papers");
      await fs.promises.mkdir(targetDirectory, { recursive: true, mode: 0o700 });
      const defaultName = arxivId ? `${arxivId.replaceAll("/", "-")}.${format === "source" ? "tar" : "pdf"}` : `${safeFilename(new URL(url).pathname.split("/").pop() || "paper")}${format === "source" ? ".tar" : ""}`;
      const filename = safeFilename(params.filename?.trim() || defaultName);
      const destination = path.join(targetDirectory, filename);
      try {
        const bytes = await downloadFile(url, destination);
        return { content: [{ type: "text", text: `Downloaded ${bytes} bytes to ${destination}\nURL: ${url}` }], details: { path: destination, url, bytes, format } };
      } catch (error) {
        await fs.promises.unlink(destination).catch(() => undefined);
        const reason = error instanceof Error ? error.message : String(error);
        return { content: [{ type: "text", text: `Could not download the paper automatically: ${reason}\n\nUser fallback: open this URL in a browser and download it manually:\n${url}\n\nThen place the downloaded file at:\n${destination}` }], details: { url, destination, format, error: reason }, isError: true };
      }
    },
  });

  pi.registerTool({
    name: "scratchpad",
    label: "Scratchpad",
    description: "Return the private per-session scratchpad path, or list its contents. Use it for cloning repositories and experiments outside the current project.",
    promptSnippet: "Use the per-session scratchpad for clones and temporary work",
    parameters: Parameters,
    async execute(_toolCallId, params) {
      directory = await ensureScratchpad();
      if (params.action === "list") {
        const entries = await fs.promises.readdir(directory, { withFileTypes: true });
        const listing = entries.map((entry) => `${entry.isDirectory() ? "d" : "f"} ${entry.name}`).join("\n");
        return { content: [{ type: "text", text: `${directory}\n${listing || "(empty)"}` }], details: { path: directory, entries: entries.map((entry) => entry.name) } };
      }
      return { content: [{ type: "text", text: directory }], details: { path: directory } };
    },
  });

  pi.registerCommand("scratchpad", {
    description: "Show the per-session scratchpad path",
    handler: async (_args, ctx) => {
      directory = await ensureScratchpad();
      ctx.ui.notify(directory, "info");
    },
  });
}
