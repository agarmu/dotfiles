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
      custom = import (rootDir + "/pkgs") pkgs;
      availableOnSystem =
        pkg:
        if pkg ? type && pkg.type == "derivation" then
          if pkg ? meta && pkg.meta ? platforms then builtins.elem system pkg.meta.platforms else true
        else
          false;
    in
    {
      packages = pkgs.lib.filterAttrs (_: availableOnSystem) custom;
    };
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
  };
  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
  };
}
