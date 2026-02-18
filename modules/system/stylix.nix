{ lib, inputs, ... }:
let
  stylix = pkgs: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };
in
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];
      stylix = (stylix pkgs) // {
        # breaks niri
        homeManagerIntegration.autoImport = false;
      };
    };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.homeModules.stylix
      ];
      stylix = (stylix pkgs);
    };
}
