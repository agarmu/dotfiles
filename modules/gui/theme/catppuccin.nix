{ inputs, ... }:
let
  theme = {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base.imports = [
    inputs.catppuccin.nixosModules.catppuccin
    theme
  ];
  flake.modules.darwin.base.imports = [
    inputs.catppuccin.darwinModules.catppuccin
    theme
  ];
  flake.modules.homeManager.base = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
      theme
    ];
    # Nixvim configures its own Catppuccin plugin.
    catppuccin.nvim.enable = false;
  };
  flake.modules.homeManager.linuxGui = { pkgs, ... }: {
    gtk = {
      enable = true;
      font = {
        name = "Source Sans 3";
        package = pkgs.source-sans;
        size = 12;
      };
      theme = {
        name = "catppuccin-mocha-mauve-standard+default";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          variant = "mocha";
        };
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };
    catppuccin.kvantum.enable = true;
  };
}
