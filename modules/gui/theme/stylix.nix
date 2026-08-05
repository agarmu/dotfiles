{ inputs, ... }:
let
  stylix-config =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
        opacity = {
          applications = 0.75;
          desktop = 0.75;
          popups = 0.75;
          terminal = 0.75;
        };
      };
    };
in
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    imports = [
      inputs.stylix.nixosModules.stylix
      stylix-config
    ];
  };
  flake.modules.darwin.base = {
    imports = [
      inputs.stylix.darwinModules.stylix
      stylix-config
    ];
  };
}
