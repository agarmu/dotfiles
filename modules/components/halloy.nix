{ lib, ... }:
{
  flake.modules.homeManager.gui = {
    programs.halloy.enable = true;
    catppuccin.halloy.enable = true;
  };
}
