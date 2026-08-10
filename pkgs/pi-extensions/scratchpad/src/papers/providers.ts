import type { Paper } from "./model.ts";
import { authorIdentifier, type ParsedQuery } from "./query.ts";

export type SearchOptions = {
  author?: string;
  yearFrom?: number;
  yearTo?: number;
  openAccess?: boolean;
  source: "all" | "openalex" | "arxiv" | "crossref";
};

export function createSearchJobs(query: ParsedQuery, options: SearchOptions, limit: number): Promise<Paper[]>[] {
  const jobs: Promise<Paper[]>[] = [];
  if (includesSource(options.source, "openalex")) jobs.push(searchOpenAlex(query, options, limit));
  if (includesSource(options.source, "arxiv")) jobs.push(searchArxiv(query, options, limit));
  if (includesSource(options.source, "crossref")) jobs.push(searchCrossref(query, options, limit));
  return jobs;
}

function includesSource(selected: SearchOptions["source"], source: Exclude<SearchOptions["source"], "all">): boolean {
  return selected === "all" || selected === source;
}

async function searchOpenAlex(query: ParsedQuery, options: SearchOptions, limit: number): Promise<Paper[]> {
  const identifier = authorIdentifier(options.author);
  const filters = [
    options.yearFrom ? `from_publication_date:${options.yearFrom}-01-01` : "",
    options.yearTo ? `to_publication_date:${options.yearTo}-12-31` : "",
    options.openAccess ? "is_oa:true" : "",
    identifier?.kind === "openalex" ? `authorships.author.id:${identifier.value}` : "",
    identifier?.kind === "orcid" ? `authorships.author.orcid:https://orcid.org/${identifier.value}` : "",
  ].filter(Boolean).join(",");
  const search = [query.positive, identifier ? "" : options.author].filter(Boolean).join(" ");
  const url = `https://api.openalex.org/works?${search ? `search=${encodeURIComponent(search)}&` : ""}per-page=${limit}${filters ? `&filter=${encodeURIComponent(filters)}` : ""}`;
  return openAlexPapers(await getJson(url));
}

async function searchArxiv(query: ParsedQuery, options: SearchOptions, limit: number): Promise<Paper[]> {
  const identifier = authorIdentifier(options.author);
  const structured = /(?:^|\s)(?:ti|au|abs|cat|co|jr|rn|id|submittedDate):/i.test(query.arxiv) || /\b(?:AND|OR|ANDNOT)\b/i.test(query.arxiv);
  const positive = query.arxiv ? (structured ? query.arxiv : `all:${query.arxiv}`) : "all:*";
  const author = options.author && !identifier && !/\bau:/i.test(query.arxiv) ? `au:${options.author}` : "";
  const dates = options.yearFrom || options.yearTo ? `submittedDate:[${options.yearFrom || 1000}01010000 TO ${options.yearTo || 9999}12312359]` : "";
  const negative = query.exclusions.map((term) => `all:"${term.replaceAll('"', '\\"')}"`).join(" ANDNOT ");
  const search = `${[positive, author, dates].filter(Boolean).join(" AND ")}${negative ? ` ANDNOT ${negative}` : ""}`;
  const response = await fetch(`https://export.arxiv.org/api/query?search_query=${encodeURIComponent(search)}&start=0&max_results=${limit}`, { headers: userAgentHeaders() });
  if (!response.ok) throw new Error(`${response.status} ${response.statusText}`);
  return arxivPapers(await response.text());
}

async function searchCrossref(query: ParsedQuery, options: SearchOptions, limit: number): Promise<Paper[]> {
  const identifier = authorIdentifier(options.author);
  const filters = [
    options.yearFrom ? `from-pub-date:${options.yearFrom}-01-01` : "",
    options.yearTo ? `until-pub-date:${options.yearTo}-12-31` : "",
    identifier?.kind === "orcid" ? `orcid:${identifier.value}` : "",
  ].filter(Boolean).join(",");
  const search = query.positive ? `query.bibliographic=${encodeURIComponent(query.positive)}&` : "";
  const author = options.author && !identifier ? `query.author=${encodeURIComponent(options.author)}&` : "";
  const url = `https://api.crossref.org/works?${search}${author}rows=${limit}${filters ? `&filter=${encodeURIComponent(filters)}` : ""}`;
  return crossrefPapers(await getJson(url));
}

async function getJson(url: string): Promise<any> {
  const response = await fetch(url, { headers: { accept: "application/json", ...userAgentHeaders() } });
  if (!response.ok) throw new Error(`${response.status} ${response.statusText}`);
  return response.json();
}

function userAgentHeaders(): Record<string, string> {
  return { "user-agent": "pi-scratchpad/0.2.0 (academic paper search)" };
}

function openAlexPapers(data: any): Paper[] {
  return (data.results || []).map((item: any) => ({
    title: stringValue(item.title),
    authors: (item.authorships || []).map((entry: any) => stringValue(entry.author?.display_name)).filter(Boolean),
    authorIds: (item.authorships || []).flatMap((entry: any) => [entry.author?.id, entry.author?.orcid]).filter(isString),
    year: item.publication_year,
    venue: stringValue(item.primary_location?.source?.display_name),
    doi: stringValue(item.doi).replace(/^https?:\/\/doi.org\//, ""),
    abstract: invertedAbstract(item.abstract_inverted_index),
    urls: [item.best_oa_location?.pdf_url, item.open_access?.oa_url, item.primary_location?.landing_page_url, item.doi].filter(isString),
    source: "OpenAlex",
    id: stringValue(item.id),
  }));
}

function invertedAbstract(index: unknown): string | undefined {
  if (!index || typeof index !== "object") return undefined;
  return Object.entries(index).flatMap(([word, positions]) => (positions as number[]).map((position) => [position, word] as const)).sort((a, b) => a[0] - b[0]).map(([, word]) => word).join(" ");
}

function arxivPapers(xml: string): Paper[] {
  return [...xml.matchAll(/<entry>([\s\S]*?)<\/entry>/g)].map(([, entry]) => {
    const id = xmlValue(entry, "id").split("/abs/").pop() || "";
    return {
      title: xmlValue(entry, "title"),
      authors: [...entry.matchAll(/<author>[\s\S]*?<name>([\s\S]*?)<\/name>[\s\S]*?<\/author>/g)].map(([, name]) => name.trim()),
      year: Number(xmlValue(entry, "published").slice(0, 4)) || undefined,
      abstract: xmlValue(entry, "summary"),
      urls: [`https://arxiv.org/abs/${id}`, `https://arxiv.org/pdf/${id}.pdf`],
      source: "arXiv",
      id,
      arxivId: id,
    };
  });
}

function xmlValue(entry: string, tag: string): string {
  const match = entry.match(new RegExp(`<${tag}(?:\\s[^>]*)?>([\\s\\S]*?)</${tag}>`));
  return match ? match[1].replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").replace(/<[^>]+>/g, "").replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").trim() : "";
}

function crossrefPapers(data: any): Paper[] {
  return (data.message?.items || []).map((item: any) => ({
    title: stringValue(item.title?.[0]),
    authors: (item.author || []).map((author: any) => [author.given, author.family].filter(Boolean).join(" ")),
    authorIds: (item.author || []).map((author: any) => author.ORCID).filter(isString),
    year: item.published?.["date-parts"]?.[0]?.[0],
    venue: stringValue(item["container-title"]?.[0]),
    doi: stringValue(item.DOI),
    urls: [item.URL, ...(item.link || []).map((link: any) => link.URL)].filter(isString),
    source: "Crossref",
  }));
}

const stringValue = (value: unknown): string => typeof value === "string" ? value : "";
const isString = (value: unknown): value is string => typeof value === "string" && value.length > 0;
