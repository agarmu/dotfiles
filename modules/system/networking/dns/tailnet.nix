{ lib, ... }:
let
  tailnetHosts = [
    "millet"
    "wheat"
    "data"
  ];
in
{
  flake.modules.nixos.base.networking.dnscryptProxyCloaking =
    tailnetHosts
    |> map (name: {
      name = "${name}.hosts.agarmu.com";
      value = "${name}.tail7434b.ts.net";
    })
    |> lib.listToAttrs;
}
