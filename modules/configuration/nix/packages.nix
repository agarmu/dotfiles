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
    with pkgs.lib;
    let
      isValidPackage =
        _: v: builtins.isAttrs v && isDerivation v && meta.availableOn pkgs.stdenv.hostPlatform v;
    in
    {
      packages = filterAttrs isValidPackage pkgs.mukul;
    };
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
  };
  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
  };
}
