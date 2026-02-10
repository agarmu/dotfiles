{ inputs, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # using determinate nix!
  flake.modules.darwin.base.nix.enable = false;
}
