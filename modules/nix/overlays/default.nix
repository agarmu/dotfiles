{ inputs, ... }:
let
  overlays = [
    inputs.nur.overlays.default
    (_final: prev: {
      niri-screen-time = inputs.niri-screen-time.packages.${prev.stdenv.hostPlatform.system}.default;
    })
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
