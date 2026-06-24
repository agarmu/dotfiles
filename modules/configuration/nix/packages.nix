{ inputs, rootDir, ... }:
let
  overlays = [
    (final: _: import (rootDir + "/pkgs") final)
  ];
in
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
      };
    in
    {
      packages = pkgs.lib.filterAttrs (_: v: builtins.isAttrs v && pkgs.lib.isDerivation v) pkgs.mukul;
    };
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
  };
  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
  };
}
