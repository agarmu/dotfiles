{ lib, inputs, ... }:
let
  cat = inputs.catppuccin;
  stylix = inputs.stylix;
  catppuccin = {
    flavor = "mocha";
  };
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    inherit catppuccin;
    imports = [
      cat.nixosModules.catppuccin
    ];
  };
  flake.modules.homeManager.base = {
    inherit catppuccin;
    imports = [
      cat.homeModules.catppuccin
    ];
  };
}
