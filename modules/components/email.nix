{ lib, ... }:
{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      catppuccin.thunderbird = {
        enable = true;
        profile = "default";
      };
      programs.thunderbird = {
        profiles.default = {
          isDefault = true;
          name = "default";
        };
      };
    };
}
