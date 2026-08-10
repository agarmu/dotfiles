import type { Paper } from "./model.ts";

export type ParsedQuery = { positive: string; arxiv: string; exclusions: string[] };
export type AuthorIdentifier = { kind: "openalex" | "orcid"; value: string };

export function parsePaperQuery(query: string): ParsedQuery {
  const exclusions: string[] = [];
  const collect = (value: string) => {
    const term = value.trim().replace(/^['"]|['"]$/g, "");
    if (term) exclusions.push(term);
  };
  let positive = query;
  positive = positive.replace(/!\s*\(([^()]*)\)/g, (_match, term: string) => { collect(term); return " "; });
  positive = positive.replace(/!\s*(?:"([^"]+)"|'([^']+)'|(\S+))/g, (_match, doubleQuoted: string, singleQuoted: string, bare: string) => { collect(doubleQuoted || singleQuoted || bare); return " "; });
  positive = positive.replace(/\bNOT\s+(?:"([^"]+)"|'([^']+)'|(\S+))/gi, (_match, doubleQuoted: string, singleQuoted: string, bare: string) => { collect(doubleQuoted || singleQuoted || bare); return " "; });
  const arxiv = normalizeBooleanQuery(positive);
  return { positive: arxiv, arxiv, exclusions };
}

function normalizeBooleanQuery(query: string): string {
  return query
    .replace(/\s*&\s*/g, " AND ")
    .replace(/\s*\|\s*/g, " OR ")
    .replace(/\s+/g, " ")
    .replace(/^(?:(?:AND|OR|ANDNOT)\s+)+/i, "")
    .replace(/(?:\s+(?:AND|OR|ANDNOT))+$/i, "")
    .replace(/\b(AND|OR|ANDNOT)(?:\s+\1\b)+/gi, "$1")
    .trim();
}

export function authorIdentifier(author?: string): AuthorIdentifier | undefined {
  if (!author?.trim()) return undefined;
  const value = normalizedAuthorId(author);
  if (/^a\d+$/i.test(value)) return { kind: "openalex", value };
  if (/^\d{4}-\d{4}-\d{4}-[\dX]{4}$/i.test(value)) return { kind: "orcid", value };
  return undefined;
}

export function paperMatches(paper: Paper, query: ParsedQuery, author?: string): boolean {
  return matchesPositiveQuery(paper, query.positive) && matchesAuthor(paper, author) && !matchesExclusion(paper, query.exclusions);
}

function matchesPositiveQuery(paper: Paper, query: string): boolean {
  if (!query.trim()) return true;
  const haystack = searchableText(paper, true);
  const clauses = query.replace(/[()]/g, " ").split(/\s+(?:OR|\|)\s+/i);
  return clauses.some((clause) => termsInClause(clause).every((term) => haystack.includes(term)));
}

function termsInClause(clause: string): string[] {
  return [...clause.matchAll(/(?:[a-z]+:)?(?:"([^"]+)"|'([^']+)'|([^\s&|]+))/gi)]
    .map((match) => (match[1] || match[2] || match[3]).toLowerCase())
    .filter((term) => term && !/^(?:and|or|andnot|not)$/.test(term));
}

function matchesAuthor(paper: Paper, author?: string): boolean {
  if (!author?.trim()) return true;
  const identifier = authorIdentifier(author);
  if (identifier) return (paper.authorIds || []).some((value) => normalizedAuthorId(value) === identifier.value);
  const names = paper.authors.join(" ").toLowerCase();
  return author.toLowerCase().split(/\s+/).filter(Boolean).every((term) => names.includes(term));
}

function matchesExclusion(paper: Paper, exclusions: string[]): boolean {
  const haystack = searchableText(paper, false);
  return exclusions.some((term) => haystack.includes(term.toLowerCase()));
}

function searchableText(paper: Paper, includeDoi: boolean): string {
  return [paper.title, ...paper.authors, paper.abstract, paper.venue, includeDoi ? paper.doi : undefined].filter(Boolean).join(" ").toLowerCase();
}

function normalizedAuthorId(value: string): string {
  return value.trim().toLowerCase().replace(/^https?:\/\/(?:www\.)?openalex\.org\//, "").replace(/^https?:\/\/(?:www\.)?orcid\.org\//, "");
}
