_:
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
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ fonts ];
      stylix.fonts = {
        serif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        };
        sansSerif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.lilex;
          name = "Lilex Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  flake.modules.darwin.base = {
    imports = [ fonts ];
  };
}
