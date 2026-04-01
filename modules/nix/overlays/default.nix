{ inputs, ... }:
let
  overlays = [
    inputs.niri.overlays.niri
    inputs.nur.overlays.default
    inputs.statix.overlays.default
  ];
in
{
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
    # TODO: merge multiple predicates
    # Predicate =
    #   pkg:
    #   builtins.elem (lib.getName pkg) [
    #     "widevine-cdm"
    #   ];
  };
  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };
}
