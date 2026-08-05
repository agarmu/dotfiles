{ inputs, ... }:
let
  stylix-config =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
        opacity = {
          applications = 0.87;
          desktop = 0.87;
          popups = 0.87;
          terminal = 0.87;
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
