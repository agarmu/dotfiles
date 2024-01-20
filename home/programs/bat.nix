{
  config,
  pkgs,
  ...
}: let
  catppuccin-macchiato-file = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/bat/ba4d16880d63e656acced2b7d4e034e4a93f74b1/Catppuccin-macchiato.tmTheme";
    sha256 = "0ydk3ysvxgdy829jfl2bwhzhwv3kh5d4k2l6047bi8dwbbid59zg";
  };
in {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
    config = {
      theme = "catppuccin-macchiato";
    };
    syntaxes = {
      typst = {
        src = pkgs.fetchFromGitHub {
          owner = "hyrious";
          repo = "typst-syntax-highlight";
          rev = "9931aee3238a639f1812e27b96e3b9017f24e4e3";
          hash = "sha256-gyXuByjfmzgFrmbwV6xIxRrphI4wEXukBpZH5rEi4MA=";
        };
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
