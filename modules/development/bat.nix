{ lib, ... }:
{
  flake.modules.homeManager.dev =
    {
      pkgs,
      ...
    }:
    {
      programs.bat = {
        enable = true;
        #extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
        themes = { };
      };
    };
}
