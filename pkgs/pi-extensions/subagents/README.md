# Pi subagents

Persistent, isolated Pi children controlled through the `subagents` tool. Each
child has its own context and accepts follow-up prompts. The parent sees only
small lifecycle metadata unless it explicitly inspects child output.

## Lifecycle

```ts
subagents({
  action: "spawn",
  task: "Inspect authentication and report relevant paths and risks.",
  label: "auth scout",
  model: "openai-codex/gpt-5.6-terra", // optional
  thinking: "low",                     // optional
  tools: ["read", "bash"],             // optional allowlist
  systemPrompt: "Do not edit files.",   // optional temporary instructions
  cwd: "/path/to/project",             // optional
})
// => Started auth scout (a1b2c3d4) with openai-codex/gpt-5.6-terra. Poll for readiness.

subagents({ action: "poll" })
// => compact metadata only: status, ready, age/running duration, unread bytes, model

subagents({ action: "wait_any" })
// => blocks until the first child becomes ready, then returns its metadata

subagents({ action: "wait_specific", id: "a1b2c3d4" })
// => blocks until the named child becomes ready, then returns its metadata

subagents({ action: "inspect", id: "a1b2c3d4", maxBytes: 4096 })
// => explicitly retrieves a bounded output chunk; details includes next cursor and more

subagents({ action: "send", id: "a1b2c3d4", task: "Now inspect tests." })
subagents({ action: "stop", id: "a1b2c3d4" })
```

`spawn`, `send`, `poll`, `wait_any`, `wait_specific`, and `stop` return compact
metadata. They never copy the delegated prompt or child response into the host context.
`wait_any` blocks until the first child is ready; `wait_specific` blocks until the
child identified by `id` is ready. `inspect` is the only
output retrieval action; it defaults to
4 KiB and allows at most 32 KiB. `read` remains an alias for `inspect`, and `list`
remains an alias for `poll`.

Tool rows in the TUI display only the child label and resolved model. The
prompt, status details, and output stay out of the transcript unless the user
opens the dedicated command below.

## User inspection

Use `/subagents` to list current children, including label, id, model, status,
age, and unread output. Use `/subagents bail` to interrupt active waits without
stopping any children. In the TUI, selecting a child opens an action picker:

- `details` — model, thinking level, status, runtime, cursors, and cwd
- `output` — retained assistant output
- `prompts` — delegated initial and follow-up tasks
- `stderr` — retained child stderr
- `wait_any` — wait until the first child is ready
- `wait_specific` — wait until the child identified by id is ready
- `stop` — terminate the child

Non-interactively, use `/subagents <id> [details|output|prompts|stderr|wait_specific|stop]`.
Waiting displays a TUI notification naming the child or number of candidates.
This command is user-only: none of its inspection data enters the host model
context.

## Context behavior

- `poll` reports whether a child is ready, its age and current running time,
  unread output size, and model without consuming output.
- `wait_any` blocks until the first selected child is ready without consuming output.
- `inspect` advances a per-child inspection cursor by default. Pass `cursor`
  to revisit a specific retained range.
- Every child retains at most 256 KiB. Cursors are absolute byte offsets.
- If unread output expires, `inspect` advances to the oldest retained cursor
  and reports `lost: true`.
- Only completed assistant text is buffered; JSON events, thinking, tool
  progress, and stderr are not copied into the parent conversation.
- Children run in RPC mode with `--no-session`, so they do not create normal Pi
  session history.
- The child cannot call `subagents`, preventing accidental recursive spawning.
- Children and temporary system-prompt files are cleaned up on stop, exit, or
  parent-session shutdown.

Tasks should be self-contained. Poll while work continues, then ask for a
concise report and inspect only the amount needed.

## Package

`default.nix` installs this local Pi package without network dependencies.
Wiring it into Pi settings is left to the consumer.
