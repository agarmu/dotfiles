{ lib, ... }:
{
  flake.modules.darwin.gui =
    {
      ...
    }:
    {
      homebrew.casks = [
        "microsoft-word"
        "microsoft-excel"
        "microsoft-powerpoint"
      ];
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghostscript
        pdftk
        qpdf
        poppler-utils
      ];
    };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [ libreoffice-qt6 ];
    };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pdfarranger ];
      programs.sioyek.enable = true;
      catppuccin.sioyek.enable = true;
    };
}
