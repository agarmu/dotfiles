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
      stylix.targets.sioyek.enable = false;
      programs.sioyek = {
        enable = true;
        config = {
          should_launch_new_window = "1";
          page_separator_width = "5";
          page_separator_color = "0.9 0.9 0.9";
        };
      };
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ];
      };
    };
}
