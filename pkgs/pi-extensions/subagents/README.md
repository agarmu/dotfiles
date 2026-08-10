# Pi subagents

Persistent, isolated Pi children controlled through the `subagents` tool. Each
child has its own context and accepts follow-up prompts. Output enters the
parent context only when explicitly read.

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
// => Started auth scout (a1b2c3d4). Read from cursor 0.

subagents({ action: "read", id: "a1b2c3d4", cursor: 0, maxBytes: 4096 })
// details includes the next cursor, status, and `more`

subagents({ action: "send", id: "a1b2c3d4", task: "Now inspect tests." })
subagents({ action: "list" })
subagents({ action: "stop", id: "a1b2c3d4" })
```

`spawn` displays a compact TUI notification containing the child label, id,
and requested model. It returns immediately after Pi accepts the initial task;
it does not wait for or stream the answer. Agents can automate the complete
workflow by polling `read`, following its returned cursor, sending follow-ups,
and stopping finished children.

## Context behavior

- `read` defaults to 12 KiB and allows at most 32 KiB per call.
- Every child retains at most 256 KiB. Cursors are absolute byte offsets.
- If unread output expires, `read` advances to the oldest retained cursor and
  reports `lost: true`.
- Only completed assistant text is buffered; JSON events, thinking, tool
  progress, and stderr are not copied into the parent conversation.
- Children run in RPC mode with `--no-session`, so they do not create normal Pi
  session history.
- The child cannot call `subagents`, preventing accidental recursive spawning.
- Children and temporary system-prompt files are cleaned up on stop, exit, or
  parent-session shutdown.

Tasks should be self-contained. Prefer small reads and ask the child for a
concise report before retrieving output.

## Package

`default.nix` installs this local Pi package without network dependencies.
Wiring it into Pi settings is left to the consumer.
