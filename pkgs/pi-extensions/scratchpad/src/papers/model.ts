export type Paper = {
  title: string;
  authors: string[];
  authorIds?: string[];
  year?: number;
  venue?: string;
  doi?: string;
  abstract?: string;
  urls: string[];
  source: string;
  sources?: string[];
  id?: string;
  arxivId?: string;
};

const MAX_CACHED_PAPERS = 200;

export class PaperCache {
  private readonly papers = new Map<string, Paper>();

  clear(): void {
    this.papers.clear();
  }

  get(identifier: string): Paper | undefined {
    const paper = this.papers.get(identifier);
    if (paper) this.put(paper);
    return paper;
  }

  put(paper: Paper): void {
    const identifier = paperIdentifier(paper);
    this.papers.delete(identifier);
    this.papers.set(identifier, paper);
    while (this.papers.size > MAX_CACHED_PAPERS) {
      const oldest = this.papers.keys().next().value;
      if (oldest === undefined) break;
      this.papers.delete(oldest);
    }
  }
}

export function safeFilename(name: string): string {
  const value = name.replace(/[^A-Za-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 160);
  return value || `paper-${Date.now()}`;
}

export function paperIdentifier(paper: Paper): string {
  if (paper.arxivId) return `arXiv:${paper.arxivId}`;
  if (paper.source === "arXiv" && paper.id) return `arXiv:${paper.id}`;
  if (paper.doi) return `doi:${paper.doi}`;
  return paper.id || `${paper.source}:${safeFilename(paper.title).slice(0, 60)}`;
}

export function paperSources(paper: Paper): string[] {
  return paper.sources || [paper.source];
}

export function deduplicatePapers(papers: Paper[]): Paper[] {
  const result: Paper[] = [];
  const aliases = new Map<string, number>();
  for (const paper of papers) addOrMergePaper(result, aliases, paper);
  return result;
}

function addOrMergePaper(result: Paper[], aliases: Map<string, number>, paper: Paper): void {
  const keys = paperKeys(paper);
  const existing = keys.map((key) => aliases.get(key)).find((index): index is number => index !== undefined);
  if (existing === undefined) {
    const index = result.push(paper) - 1;
    for (const key of keys) aliases.set(key, index);
    return;
  }
  result[existing] = mergePapers(result[existing], paper);
  for (const key of paperKeys(result[existing])) aliases.set(key, existing);
}

function paperKeys(paper: Paper): string[] {
  const doi = paper.doi?.trim().toLowerCase().replace(/^https?:\/\/(?:dx\.)?doi\.org\//, "");
  const arxiv = normalizedArxivId(paper);
  const title = paper.title.normalize("NFKD").toLowerCase().replace(/[^\p{L}\p{N}]+/gu, " ").trim();
  return [doi && `doi:${doi}`, arxiv && `arxiv:${arxiv}`, title && `title:${title}:${paper.year || ""}`].filter((value): value is string => Boolean(value));
}

function normalizedArxivId(paper: Paper): string | undefined {
  const direct = paper.arxivId || (paper.source === "arXiv" ? paper.id : undefined);
  const fromUrl = paper.urls.map((url) => url.match(/arxiv\.org\/(?:abs|pdf|e-print)\/([^?#]+?)(?:\.pdf)?(?:[?#]|$)/i)?.[1]).find(Boolean);
  return (direct || fromUrl)?.trim().replace(/\.pdf$/i, "").replace(/v\d+$/i, "").toLowerCase() || undefined;
}

function mergePapers(first: Paper, second: Paper): Paper {
  return {
    ...first,
    title: second.title.length > first.title.length ? second.title : first.title,
    authors: second.authors.length > first.authors.length ? second.authors : first.authors,
    authorIds: [...new Set([...(first.authorIds || []), ...(second.authorIds || [])])],
    year: first.year || second.year,
    venue: first.venue || second.venue,
    doi: first.doi || second.doi,
    abstract: (second.abstract?.length || 0) > (first.abstract?.length || 0) ? second.abstract : first.abstract,
    urls: [...new Set([...first.urls, ...second.urls])],
    sources: [...new Set([...paperSources(first), ...paperSources(second)])],
    arxivId: first.arxivId || second.arxivId || (second.source === "arXiv" ? second.id : undefined),
  };
}
