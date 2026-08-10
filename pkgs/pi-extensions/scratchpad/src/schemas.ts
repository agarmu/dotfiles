import { Type } from "typebox";

export const ScratchpadParameters = Type.Object({
  action: Type.Optional(Type.Union([Type.Literal("path"), Type.Literal("list")])),
});

export const PaperSearchParameters = Type.Object({
  query: Type.String({ description: "Free-text or provider-aware query; quoted phrases, AND/OR, exclusions, and arXiv fields are supported." }),
  author: Type.Optional(Type.String({ description: "Author name, ORCID, or OpenAlex author id." })),
  yearFrom: Type.Optional(Type.Integer({ minimum: 1000, description: "Earliest publication year (inclusive)." })),
  yearTo: Type.Optional(Type.Integer({ minimum: 1000, description: "Latest publication year (inclusive)." })),
  openAccess: Type.Optional(Type.Boolean({ description: "Only records marked open access where supported." })),
  source: Type.Optional(Type.Union([Type.Literal("all"), Type.Literal("openalex"), Type.Literal("arxiv"), Type.Literal("crossref")])),
  maxResults: Type.Optional(Type.Integer({ minimum: 1, maximum: 10, description: "Maximum total deduplicated results (default 5)." })),
  includeVerificationFailures: Type.Optional(Type.Boolean({ description: "Include a bounded sample of locally rejected candidates." })),
});

export const PaperDetailsParameters = Type.Object({
  identifier: Type.String({ description: "Identifier returned by paper_search." }),
  includeAbstract: Type.Optional(Type.Boolean({ description: "Include the cached abstract (default true)." })),
  maxAbstractChars: Type.Optional(Type.Integer({ minimum: 200, maximum: 8000, description: "Maximum abstract characters (default 3000)." })),
});

export const PaperReadParameters = Type.Object({
  action: Type.Union([Type.Literal("prepare"), Type.Literal("extract")]),
  path: Type.String({ description: "Downloaded paper path for prepare, or prepared corpus path for extract." }),
  request: Type.Optional(Type.String({ description: "Material whose start/end positions the indexing subagent should locate." })),
  start: Type.Optional(Type.Integer({ minimum: 1, description: "Inclusive 1-based start line." })),
  end: Type.Optional(Type.Integer({ minimum: 1, description: "Inclusive 1-based end line." })),
  maxChars: Type.Optional(Type.Integer({ minimum: 500, maximum: 30000, description: "Maximum extracted characters (default 12000)." })),
});

export const PaperDownloadParameters = Type.Object({
  url: Type.Optional(Type.String({ description: "Direct PDF or source URL." })),
  arxivId: Type.Optional(Type.String({ description: "arXiv identifier, e.g. 2301.01234v2." })),
  format: Type.Optional(Type.Union([Type.Literal("pdf"), Type.Literal("source")])),
  filename: Type.Optional(Type.String({ description: "Optional output filename." })),
});
