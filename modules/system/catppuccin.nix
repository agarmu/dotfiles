{ lib, inputs, ... }:
let
  catppuccin = inputs.catppuccin;
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    imports = [
      catppuccin.nixosModules.catppuccin
    ];
    catppuccin = {
      flavor = "mocha";
      tty.enable = true;
      grub.enable = true;
    };
  };
  flake.modules.homeManager.base = {
    imports = [
      catppuccin.homeModules.catppuccin
    ];
  };
}
