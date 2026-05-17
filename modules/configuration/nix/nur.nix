{ inputs, ... }:
let
  overlays = [
    inputs.nur.overlays.default
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
}
