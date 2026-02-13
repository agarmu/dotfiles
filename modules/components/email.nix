{ lib, inputs, ... }:
{
  flake-file.inputs.mio19 = {
    url = "github:mio-19/nurpkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      catppuccin.thunderbird = {
        enable = true;
        profile = "default";
      };
      programs.thunderbird = {
        enable = true;
        package = inputs.mio19.outputs.packages.${pkgs.stdenv.system}.betterbird;
        profiles.default = {
          isDefault = true;
        };
      };
    };
}
