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
      home.packages = [
        # inputs.mio19.packages."${pkgs.stdenv.hostPlatform.system}".betterbird
      ];
      programs.thunderbird = {
        enable = true;
<<<<<<< Updated upstream
=======
        # package = inputs.mio19.outputs.packages.${pkgs.stdenv.system}.betterbird;
>>>>>>> Stashed changes
        profiles.default = {
          isDefault = true;
        };
      };
    };
}
