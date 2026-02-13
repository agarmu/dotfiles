{ inputs, ... }:
let
  overlays = [
    inputs.niri.overlays.niri
    inputs.nur.overlays.default
    inputs.ioskeley.overlays.default
  ];
in
{
  flake.modules.nixos.base.nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  flake.modules.darwin.base.nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };
}
