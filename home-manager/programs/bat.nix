{
  config,
  pkgs,
  ...
}: let
  draculatheme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/bat/ba4d16880d63e656acced2b7d4e034e4a93f74b1/Catppuccin-macchiato.tmTheme";
    sha256 = "0ydk3ysvxgdy829jfl2bwhzhwv3kh5d4k2l6047bi8dwbbid59zg";
  };
in {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batgrep batman batpipe batwatch batdiff prettybat];
    config = {
      theme = "Catppuccin-macchiato";
    };
    themes = {
      dracula = builtins.readFile draculatheme;
    };
  };
}
