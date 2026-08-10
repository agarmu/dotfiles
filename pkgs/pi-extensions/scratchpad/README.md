# Pi scratchpad

Creates a private scratchpad at `$PI_HOME/scratchpad/$PI_SESSION_ID` for each Pi session. If `PI_HOME` is unset, `PI_CODING_AGENT_DIR` (or `~/.pi`) is used.

The path is included in the agent system prompt, exposed through the `scratchpad` tool, and shown by `/scratchpad`. It is suitable for temporary files and directories (anything you would otherwise put under `/tmp`), cloned repositories, and experiments without changing the current project. Agents are instructed not to use `/tmp` for agent-created temporary work.

When Pi Sandbox is installed, the scratchpad root is automatically added to `$PI_CODING_AGENT_DIR/sandbox.json` (or `~/.pi/agent/sandbox.json`) as an allowed read/write path, so sandbox permission checks do not prompt for scratchpad work. Set `PI_SCRATCHPAD_SANDBOX=0` to opt out.

## Academic paper search

The extension provides `paper_search` for OpenAlex, arXiv, and Crossref, plus `paper_download` for PDFs and arXiv source archives. Queries may use Boolean operators including `&`/`AND`, `|`/`OR`, and exclusions such as `! (b)`, `!(b)`, `!"b"`, or `NOT b`; for example `transformers & !(vision)`. arXiv field syntax such as `ti:"neural scaling laws" AND au:Hoffmann` is also supported. Optional `author`, `yearFrom`, `yearTo`, and `openAccess` filters are supported.

Search fetches a larger candidate pool, verifies it locally, merges cross-provider duplicates by DOI, arXiv id, or normalized title/year, and applies `maxResults` as a global result cap. Verified metadata is cached in memory for the session (up to 200 papers). Search output stays compact; use `paper_details` with a returned identifier to retrieve complete cached metadata and a bounded abstract. The cache is cleared when a new session starts.

Downloads are stored under the session scratchpad's `papers` directory. `paper_read` prepares PDF, TeX, text, Markdown, or arXiv source archives as a stable line-addressed corpus. Its `prepare` result supplies a task for `subagents`: use the weakest/free configured model to return only JSON `[{"label":"...","start":1,"end":20}]`, with inclusive 1-based positions. Then call `paper_read` with `action="extract"` to retrieve those lines deterministically under a character cap. Set `PI_PAPER_INDEX_MODEL` to name the cheap indexing model explicitly.

Google Scholar is not scraped because it has no stable public API. Search results include a Scholar discovery URL, and any open PDF or arXiv URL can be passed to `paper_download`. If an automatic download fails, the tool reports the URL and the exact scratchpad destination so the user can download it manually.

## Source layout

- `src/index.ts` wires session hooks and tool modules.
- `src/session.ts` owns scratchpad paths and Pi Sandbox integration.
- `src/schemas.ts` contains tool input schemas.
- `src/papers/` contains query parsing, provider adapters, caching/deduplication, downloads, and corpus preparation.
- `src/tools/` contains one registration module per tool.
