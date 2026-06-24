{ inputs, ... }:
let
  config = {
    overlays = [
      inputs.nur.overlays.default
    ];
    # TODO: merge multiple predicates
    # Predicate =
    #   pkg:
    #   builtins.elem (lib.getName pkg) [
    #     "widevine-cdm"
    #   ];
    config.allowUnfree = true;
  };
in
{
  flake.modules.nixos.base.nixpkgs = config;
  flake.modules.darwin.base.nixpkgs = config;
}
