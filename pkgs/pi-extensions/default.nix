{
  build-support,
  callPackage,
  lib,
}:
let
  inherit (build-support) wrapPiExtension;
in
{
  pi-sandbox = callPackage ./pi-sandbox { };
  web-search = callPackage ./web-search { };
  context-guard = callPackage ./context-guard { };
  context = callPackage ./context { };
  notify = callPackage ./notify { };
  statusline = callPackage ./statusline { };
  subagents = callPackage ./subagents { };
  todo = callPackage ./todo { };
  fff = callPackage ./fff { };
  rtk = callPackage ./rtk { };
  dynamic-footer = callPackage ./dynamic-footer { };
  model-picker = callPackage ./model-picker { };
  better-openai = callPackage ./better-openai { };
  scratchpad = callPackage ./scratchpad { };
  loop = callPackage ./loop { };
}
|> lib.mapAttrs (_: package: wrapPiExtension { inherit package; })
