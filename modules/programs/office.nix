{ lib, ... }:
{
  flake.modules.darwin.gui =
    {
      ...
    }:
    {
      homebrew.casks = [
        "microsoft-teams"
        "microsoft-word"
        "microsoft-excel"
        "microsoft-powerpoint"
        "microsoft-onenote"
      ];
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghostscript
        pdftk
        qpdf
      ];
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
