_: {
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

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pdfarranger ];
      programs.sioyek = {
        enable = true;
        config.should_launch_new_window = "1";
      };
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ];
      };
    };
}
