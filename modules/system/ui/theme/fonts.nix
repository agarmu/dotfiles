{ lib, ... }:
let
  fonts =
    { pkgs, ... }:
    let
      toDrvList = attrs: lib.filter lib.isDerivation (lib.attrValues attrs);
    in
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
        ]
        ++ (toDrvList tex-gyre)
        ++ (toDrvList tex-gyre-math);
    };
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ fonts ];
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
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
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
  flake.modules.darwin.base = {
    imports = [ fonts ];
  };
}
