# Pi scratchpad

Creates a private scratchpad at `$PI_HOME/scratchpad/$PI_SESSION_ID` for each Pi session. If `PI_HOME` is unset, `PI_CODING_AGENT_DIR` (or `~/.pi`) is used.

The path is included in the agent system prompt, exposed through the `scratchpad` tool, and shown by `/scratchpad`. It is suitable for cloning repositories and running experiments without changing the current project.

When Guardrails is installed, the scratchpad root is automatically added as an allowed directory in `extensions/guardrails.json`, so path-access checks do not prompt for scratchpad work. Set `PI_SCRATCHPAD_GUARDRAILS=0` to opt out.

## Academic paper search

The extension provides `paper_search` for OpenAlex, arXiv, and Crossref, plus `paper_download` for PDFs and arXiv source archives. Queries may use Boolean operators including `&`/`AND`, `|`/`OR`, and exclusions such as `! (b)`, `!(b)`, `!"b"`, or `NOT b`; for example `transformers & !(vision)`. Results are locally re-checked against the positive and negative query terms and returned compactly as identifiers plus short metadata. The tool reports how many candidates failed verification but hides them by default; set `includeVerificationFailures` only in a follow-up when those candidates are needed. Set `includeAbstract` only when more detail is needed. arXiv field syntax such as `ti:"neural scaling laws" AND au:Hoffmann` is also supported. Optional `author`, `yearFrom`, `yearTo`, and `openAccess` filters are supported. Downloads are stored under the session scratchpad's `papers` directory.

Google Scholar is not scraped because it has no stable public API. Search results include a Scholar discovery URL, and any open PDF or arXiv URL can be passed to `paper_download`. If an automatic download fails, the tool reports the URL and the exact scratchpad destination so the user can download it manually.
