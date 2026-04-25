{ inputs, ... }:
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
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
        opacity = {
          applications = 0.85;
          desktop = 0.85;
          popups = 0.85;
          terminal = 0.65;
        };
      };
    };
}
