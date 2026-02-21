_: {
  flake.modules.homeManager.nixosGui = {
    programs.imv.enable = true;
    xdg.mimeApps.defaultApplications = {
      "image/png" = [ "imv-dir.desktop" ];
      "image/jpeg" = [ "imv-dir.desktop" ];
      "image/gif" = [ "imv-dir.desktop" ];
      "image/webp" = [ "imv-dir.desktop" ];
      "image/svg+xml" = [ "imv-dir.desktop" ];
      "image/bmp" = [ "imv-dir.desktop" ];
      "image/tiff" = [ "imv-dir.desktop" ];
    };
  };
}
