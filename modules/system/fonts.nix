{ lib, ... }:
let
  fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        inconsolata
        cm_unicode
        lmodern
        ibm-plex
        lilex
        nerd-fonts.lilex
        noto-fonts-color-emoji
      ];
    };
in
{
  flake.modules.nixos.base = {
    imports = [ fonts ];
  };
  flake.modules.darwin.base = {
    imports = [ fonts ];
  };
  flake.modules.homeManager.base = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "IBM Plex Serif" ];
        sansSerif = [ "IBM Plex Sans" ];
        monospace = [ "Lilex Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
