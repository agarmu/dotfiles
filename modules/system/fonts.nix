{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        inconsolata
        cascadia-code
        cm_unicode
        lmodern
        ibm-plex
      ];
    };
}
