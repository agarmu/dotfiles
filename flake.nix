# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    apple-silicon = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-apple-silicon";
    };
    betterfox = {
      flake = false;
      url = "github:yokoffing/Betterfox";
    };
    catppuccin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:catppuccin/nix";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    firefox-addons = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    gdb-dashboard = {
      flake = false;
      url = "github:cyrus-and/gdb-dashboard";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    homebrew-cask = {
      flake = false;
      url = "github:homebrew/homebrew-cask";
    };
    homebrew-core = {
      flake = false;
      url = "github:homebrew/homebrew-core";
    };
    import-tree.url = "github:vic/import-tree";
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sodiboo/niri-flake";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nix-wallpaper = {
      flake = false;
      url = "https://raw.githubusercontent.com/nixos/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato.png";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    zen-browser = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:0xc000022070/zen-browser-flake";
    };
    zen-catppuccin = {
      flake = false;
      url = "github:catppuccin/zen-browser";
    };
  };

}
