import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { PaperSearchParameters } from "../schemas.ts";
import { PaperCache, deduplicatePapers, paperIdentifier, paperSources, type Paper } from "../papers/model.ts";
import { createSearchJobs } from "../papers/providers.ts";
import { paperMatches, parsePaperQuery } from "../papers/query.ts";

export function registerPaperSearch(pi: ExtensionAPI, cache: PaperCache): void {
  pi.registerTool({
    name: "paper_search",
    label: "Academic Papers",
    description: "Search OpenAlex, arXiv, and Crossref; verify, deduplicate, globally limit, and cache compact results.",
    promptSnippet: "Search and cache compact academic-paper metadata",
    promptGuidelines: [
      "Use ordinary queries and known author/year/open-access constraints; exclusions may use `topic & !(excluded)`.",
      "Use paper_details only for shortlisted identifiers, then paper_download when contents are needed.",
    ],
    parameters: PaperSearchParameters,
    async execute(_toolCallId, params) {
      const queryText = params.query.trim();
      if (!queryText) return errorResult("query is required");
      const query = parsePaperQuery(queryText);
      const limit = params.maxResults || 5;
      const jobs = createSearchJobs(query, {
        author: params.author?.trim(),
        yearFrom: params.yearFrom,
        yearTo: params.yearTo,
        openAccess: params.openAccess,
        source: params.source || "all",
      }, Math.min(limit * 3, 30));
      const settled = await Promise.allSettled(jobs);
      return buildSearchResult(settled, queryText, params.author?.trim(), limit, Boolean(params.includeVerificationFailures), cache, query);
    },
  });
}

function buildSearchResult(settled: PromiseSettledResult<Paper[]>[], queryText: string, author: string | undefined, limit: number, includeFailures: boolean, cache: PaperCache, query: ReturnType<typeof parsePaperQuery>) {
  const fetched = settled.flatMap((result) => result.status === "fulfilled" ? result.value : []);
  const verified = fetched.filter((paper) => paperMatches(paper, query, author));
  const rejected = fetched.filter((paper) => !paperMatches(paper, query, author));
  const deduplicated = deduplicatePapers(verified);
  for (const paper of deduplicated) cache.put(paper);
  const returned = deduplicated.slice(0, limit);
  const unavailable = settled.filter((result): result is PromiseRejectedResult => result.status === "rejected").map(rejectionMessage);
  const scholar = `https://scholar.google.com/scholar?q=${encodeURIComponent([queryText, author].filter(Boolean).join(" "))}`;
  const content = formatSearchContent(returned, verified.length - deduplicated.length, rejected, includeFailures, limit, unavailable, scholar);
  return {
    content: [{ type: "text" as const, text: content }],
    details: {
      results: returned.map(compactPaper),
      unavailableSources: unavailable,
      candidates: { fetched: fetched.length, verified: verified.length, deduplicated: deduplicated.length, returned: returned.length },
      verification: { checked: fetched.length, rejected: rejected.length, rejectedResultsIncluded: includeFailures },
      googleScholarUrl: scholar,
    },
  };
}

function formatSearchContent(papers: Paper[], merged: number, rejected: Paper[], includeFailures: boolean, limit: number, unavailable: string[], scholar: string): string {
  const sections = [papers.length ? papers.map(formatPaper).join("\n\n") : "No verified papers found."];
  if (merged) sections.push(`Merged ${merged} duplicate record(s) across providers.`);
  if (rejected.length) sections.push(`${rejected.length} candidate(s) failed local verification.${includeFailures ? "" : " Set includeVerificationFailures=true to inspect a bounded sample."}`);
  if (includeFailures && rejected.length) sections.push(`Verification-failed candidates:\n${rejected.slice(0, limit).map(formatPaper).join("\n\n")}`);
  if (unavailable.length) sections.push(`Unavailable sources: ${unavailable.join("; ")}`);
  sections.push(`Google Scholar discovery: ${scholar}`);
  return sections.join("\n\n");
}

function formatPaper(paper: Paper, index?: number): string {
  const prefix = index === undefined ? "-" : `${index + 1}.`;
  const authors = paper.authors.slice(0, 3).join(", ") || "unknown authors";
  const suffix = `${paper.authors.length > 3 ? " et al." : ""}${paper.year ? ` · ${paper.year}` : ""}${paper.venue ? ` · ${paper.venue}` : ""}`;
  return `${prefix} ${paperIdentifier(paper)} — ${paper.title || "(untitled)"}\n   ${authors}${suffix}${paper.urls[0] ? `\n   Link: ${paper.urls[0]}` : ""}`;
}

function compactPaper(paper: Paper) {
  return { identifier: paperIdentifier(paper), title: paper.title, authors: paper.authors.slice(0, 3), year: paper.year, venue: paper.venue, doi: paper.doi, sources: paperSources(paper), urls: paper.urls.slice(0, 1) };
}

function rejectionMessage(result: PromiseRejectedResult): string {
  return result.reason instanceof Error ? result.reason.message : String(result.reason);
}

function errorResult(message: string) {
  return { content: [{ type: "text" as const, text: message }], isError: true };
}
