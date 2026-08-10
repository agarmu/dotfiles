import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { PaperDetailsParameters } from "../schemas.ts";
import { PaperCache, paperSources, type Paper } from "../papers/model.ts";

export function registerPaperDetails(pi: ExtensionAPI, cache: PaperCache): void {
  pi.registerTool({
    name: "paper_details",
    label: "Paper Details",
    description: "Return cached metadata and a bounded abstract for one paper_search identifier.",
    promptSnippet: "Retrieve details for one cached search result",
    promptGuidelines: ["Call paper_search first and request details only for shortlisted identifiers."],
    parameters: PaperDetailsParameters,
    async execute(_toolCallId, params) {
      const identifier = params.identifier.trim();
      const paper = cache.get(identifier);
      if (!paper) return { content: [{ type: "text", text: `No cached paper matches ${identifier}. Run paper_search in this session first.` }], isError: true };
      return detailsResult(identifier, paper, params.includeAbstract !== false, params.maxAbstractChars || 3000);
    },
  });
}

function detailsResult(identifier: string, paper: Paper, includeAbstract: boolean, maxAbstractChars: number) {
  const fullAbstract = paper.abstract?.trim();
  const abstract = includeAbstract && fullAbstract ? fullAbstract.slice(0, maxAbstractChars) : undefined;
  const truncated = Boolean(abstract && fullAbstract && abstract.length < fullAbstract.length);
  const fields = [
    `${identifier} — ${paper.title || "(untitled)"}`,
    `Authors: ${paper.authors.join(", ") || "unknown"}`,
    paper.year ? `Year: ${paper.year}` : "",
    paper.venue ? `Venue: ${paper.venue}` : "",
    paper.doi ? `DOI: ${paper.doi}` : "",
    `Sources: ${paperSources(paper).join(", ")}`,
    paper.urls.length ? `URLs:\n${paper.urls.map((url) => `- ${url}`).join("\n")}` : "",
    abstract ? `Abstract${truncated ? " (truncated)" : ""}:\n${abstract}` : includeAbstract ? "Abstract: unavailable" : "",
  ].filter(Boolean);
  return {
    content: [{ type: "text" as const, text: fields.join("\n\n") }],
    details: { identifier, title: paper.title, authors: paper.authors, year: paper.year, venue: paper.venue, doi: paper.doi, arxivId: paper.arxivId, sources: paperSources(paper), urls: paper.urls, abstractIncluded: Boolean(abstract), abstractTruncated: truncated },
  };
}
