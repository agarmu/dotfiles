{
  pkgs,
  inputs,
  ...
}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
    config = {
      theme = "base16";
    };
    syntaxes = {
      typst = {
        src = inputs.bat-typst-syntax;
        file = "Typst.sublime-syntax";
      };
    };
    themes = {};
  };
}
