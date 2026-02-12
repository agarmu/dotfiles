{ lib, ... }:
{
  flake.modules.homeManager.gui = {
    programs.mpv.enable = true;
    catppuccin.mpv.enable = true;
  };
}
