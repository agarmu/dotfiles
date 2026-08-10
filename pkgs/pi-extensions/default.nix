{ build-support, callPackage }:
let
  inherit (build-support) buildPiSubagent;
in
{
  guardrails = buildPiSubagent { package = callPackage ./guardrails { }; };
  web-search = buildPiSubagent { package = callPackage ./web-search { }; };
  context-guard = buildPiSubagent { package = callPackage ./context-guard { }; };
  context = buildPiSubagent { package = callPackage ./context { }; };
  notify = buildPiSubagent { package = callPackage ./notify { }; };
  statusline = buildPiSubagent { package = callPackage ./statusline { }; };
  subagents = buildPiSubagent { package = callPackage ./subagents { }; };
  todo = buildPiSubagent { package = callPackage ./todo { }; };
  better-openai = buildPiSubagent { package = callPackage ./better-openai { }; };
  scratchpad = buildPiSubagent { package = callPackage ./scratchpad { }; };
}
