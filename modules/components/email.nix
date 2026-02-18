{ lib, inputs, ... }:
{
  flake-file.inputs.mio19 = {
    url = "github:mio-19/nurpkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        # inputs.mio19.packages."${pkgs.stdenv.hostPlatform.system}".betterbird
      ];
      programs.thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
        };
      };
    };
}
