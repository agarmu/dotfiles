{ lib, inputs, ... }:
let
  inp = inputs.catppuccin;
  catppuccin = {
    flavor = "mocha";
  };
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    inherit catppuccin;
    imports = [
      inp.nixosModules.catppuccin
    ];
  };
  flake.modules.homeManager.base = {
    inherit catppuccin;
    imports = [
      inp.homeModules.catppuccin
    ];
  };
}
