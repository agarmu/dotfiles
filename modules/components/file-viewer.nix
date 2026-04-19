{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs.kdePackages; [
        dolphin
        partitionmanager
      ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.kde.dolphin.desktop";
      };
    };
}
