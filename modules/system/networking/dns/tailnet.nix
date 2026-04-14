{ lib, ... }:
let
  tailnetHosts = [
    "millet"
    "wheat"
    "data"
  ];
in
{
  flake.modules.nixos.base.networking.extraProxies =
    tailnetHosts
    |> map (name: {
      name = "${name}.local";
      value = "${name}.tail7434b.ts.net";
    })
    |> lib.listToAttrs;
}
