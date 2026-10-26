{ lib, ... }:
let
  toDrvList = attrs: lib.filter lib.isDerivation (lib.attrValues attrs);
  fonts =
    { pkgs, ... }:
    {
      fonts.packages =
        with pkgs;
        [
          adwaita-fonts
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
          nordwand-mono
          league-of-moveable-type
          national-park-typeface
          kpfonts
        ]
        ++ (toDrvList tex-gyre)
        ++ (toDrvList tex-gyre-math);
    };
in
{
  flake.modules.nixos.base = {
    imports = [
      fonts
    ];
  };

  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gnome-font-viewer ];
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [ "Source Serif 4" ];
          sansSerif = [ "Source Sans 3" ];
          monospace = [ "Nordwand Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

  flake.modules.darwin.base = {
    imports = [
      fonts
    ];
  };
}
