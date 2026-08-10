{ build-support, callPackage }:
let
  inherit (build-support) buildPiSubagent;
in
{
  pi-sandbox = buildPiSubagent { package = callPackage ./pi-sandbox { }; };
  web-search = buildPiSubagent { package = callPackage ./web-search { }; };
  context-guard = buildPiSubagent { package = callPackage ./context-guard { }; };
  context = buildPiSubagent { package = callPackage ./context { }; };
  notify = buildPiSubagent { package = callPackage ./notify { }; };
  statusline = buildPiSubagent { package = callPackage ./statusline { }; };
  subagents = buildPiSubagent { package = callPackage ./subagents { }; };
  todo = buildPiSubagent { package = callPackage ./todo { }; };
  fff = buildPiSubagent { package = callPackage ./fff { }; };
  rtk = buildPiSubagent { package = callPackage ./rtk { }; };
  dynamic-footer = buildPiSubagent { package = callPackage ./dynamic-footer { }; };
  model-picker = buildPiSubagent { package = callPackage ./model-picker { }; };
  better-openai = buildPiSubagent { package = callPackage ./better-openai { }; };
  scratchpad = buildPiSubagent { package = callPackage ./scratchpad { }; };
  loop = buildPiSubagent { package = callPackage ./loop { }; };
}
