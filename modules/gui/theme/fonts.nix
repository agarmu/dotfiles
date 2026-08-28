{ lib, ... }:
let
  toDrvList = attrs: lib.filter lib.isDerivation (lib.attrValues attrs);
  fonts =
    { pkgs, ... }:
    {
      fonts.packages =
        with pkgs;
        [
          inconsolata
          cm_unicode
          lmodern
          ibm-plex
          source-sans
          source-serif
          nerd-fonts.jetbrains-mono
          noto-fonts-color-emoji
          libertinus
          iosevka-kian-bin
          league-of-moveable-type
          national-park-typeface
          kpfonts
        ]
        ++ (toDrvList tex-gyre)
        ++ (toDrvList tex-gyre-math);
    };
  stylix-fonts =
    { pkgs, ... }:
    {
      stylix.fonts = {
        serif = {
          package = pkgs.source-serif;
          name = "Source Serif 4";
        };
        sansSerif = {
          package = pkgs.source-sans;
          name = "Source Sans 3";
        };
        monospace = {
          package = pkgs.iosevka-kian-bin;
          name = "Iosevka Kian Term";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          desktop = 14;
        };
      };
    };
in
{
  flake.modules.nixos.base = {
    imports = [
      fonts
      stylix-fonts
    ];
  };

  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gnome-font-viewer ];
    };

  flake.modules.darwin.base = {
    imports = [
      fonts
      stylix-fonts
    ];
  };
}
