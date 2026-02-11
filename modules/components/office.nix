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
      programs.sioyek.enable = true;
    };

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    lib.mkMerge [
      {
        home.packages = with pkgs; [ pdfarranger ];
      }
      (lib.mkIf (pkgs.stdenv.isLinux) {
        home.packages = with pkgs; [ libreoffice-qt6 ];
      })
    ];
}
