{ lib, inputs, ... }:
let
  stylix = inputs.stylix;
in
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    imports = [
      stylix.nixosModules.stylix
    ];
    stylix = {
      enable = false;
      # breaks niri
      homeManagerIntegration.autoImport = false;
    };
  };
  flake.modules.homeManager.base = {
    imports = [
      stylix.homeModules.stylix
    ];
  };
}
