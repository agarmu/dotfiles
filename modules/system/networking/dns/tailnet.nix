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
      name = "${name}.agarmu";
      value = "${name}.tail7434b.ts.net";
    })
    |> lib.listToAttrs;
}
