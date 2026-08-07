{ callPackage }: {
  guardrails = callPackage ./guardrails { };
  subagents = callPackage ./subagents { };
  web-search = callPackage ./web-search { };
  context-guard = callPackage ./context-guard { };
  context = callPackage ./context { };
  notify = callPackage ./notify { };
  statusline = callPackage ./statusline { };
  todo = callPackage ./todo { };
  better-openai = callPackage ./better-openai { };
}
