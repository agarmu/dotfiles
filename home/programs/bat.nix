{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
    config = {
      theme = "catppuccin-macchiato";
    };
    syntaxes = {
      typst = {
        src = inputs.bat-typst-syntax;
        file = "Typst.sublime-syntax";
      };
    };
    themes = {
      catppuccin-macchiato = {
        src = inputs.bat-catppuccin-plug;
        file = "Catppuccin-macchiato.tmTheme";
      };
    };
  };
}
