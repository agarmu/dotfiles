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
        noto-fonts-color-emoji
        ioskeley-mono
        ioskeley-mono-nerd
      ];
    };
in
{
  flake-file.inputs.ioskeley = {
    url = "github:agarmu/ioskeley-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
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
        monospace = [ "IoskeleyMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
