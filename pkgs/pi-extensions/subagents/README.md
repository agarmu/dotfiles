# Pi subagents

A local Pi package that registers `subagents`: a one-shot child Pi
process with its own context window. Unlike role-based subagent packages, no
agent markdown file or persistent agent name is required.

## Tool shape

```ts
subagents({
  task: "Inspect the authentication flow and return relevant files and risks.",
  label: "auth scout",                 // optional display name
  systemPrompt: "Be concise; do not edit files.", // optional, temporary
  tools: ["read", "bash"],             // optional child allowlist
  model: "openai-codex/gpt-5.6",        // optional Pi model pattern
  thinking: "low",                     // optional Pi thinking level
  cwd: "/path/to/project",             // optional child cwd
})
```

`task` must be self-contained. The child does not receive the parent
conversation. `systemPrompt` is appended to the child's ordinary Pi system
prompt and is stored in a temporary, owner-only file for the duration of the
run. The child runs with `--no-session`, returns only its final text, and has
the `subagents` tool excluded from its tool set to prevent accidental recursion.

The package relies only on Pi's documented extension API and CLI flags:
`registerTool`, `--mode json`, `--print`, `--no-session`,
`--append-system-prompt`, `--tools`, `--exclude-tools`, `--model`, and
`--thinking`.

## Local layout

- `default.nix` packages the local source without network dependencies.
- `package.json` is a Pi package manifest.
- `src/index.ts` is the extension entry point.

Wiring the resulting derivation into Pi settings is deliberately left to the
consumer.
