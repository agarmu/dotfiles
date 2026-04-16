{
  flake.modules.darwin.gui = {
    homebrew.casks = [
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
    ];
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.libreoffice-fresh
        /*
          TODO: switch to custom build once I have
          	   a proper build server
          	(pkgs.libreoffice-fresh.override {
                    unwrapped = pkgs.libreoffice-fresh-unwrapped.override {
                      withHelp = false;
                      langs = [ "en-US" "en-GB" ];
                    };
                  })
        */
      ];
      xdg.mimeApps.defaultApplications = {
        "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet" = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.presentation" = [ "impress.desktop" ];
        "application/msword" = [ "writer.desktop" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];
        "application/vnd.ms-powerpoint" = [ "impress.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "calc.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress.desktop" ];
      };
    };
}
