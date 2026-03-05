{ lib, inputs, ... }:
let
  overlays = [
    inputs.nur.overlays.default
  ];
in
{
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "widevine-cdm"
      ];
  };
  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };
}
