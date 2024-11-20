{
  pkgs,
  inputs,
  ...
}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
    config = {
      theme = "tokyonight_night";
    };
    syntaxes = {
      typst = {
        src = inputs.bat-typst-syntax;
        file = "Typst.sublime-syntax";
      };
    };
    themes = {
      tokyonight_night = {
        src = inputs.bat-tokyonight-theme;
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
  };
}
