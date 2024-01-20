{
  config,
  pkgs,
  inputs,
  ...
}: let
  catppuccin-macchiato-file = "${inputs.bat-catppuccin-plug}/Catppuccin-macchiato.tmTheme";
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
        src = catppuccin-macchiato-file;
      };
    };
  };
}
