{ callPackage }: {
  guardrails = callPackage ./guardrails { };
  web-search = callPackage ./web-search { };
  context-guard = callPackage ./context-guard { };
  context = callPackage ./context { };
  notify = callPackage ./notify { };
  statusline = callPackage ./statusline { };
  subagents = callPackage ./subagents { };
  todo = callPackage ./todo { };
  better-openai = callPackage ./better-openai { };
}
