{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs.kdePackages; [
        dolphin
        partitionmanager
        kio-extras
        ark
      ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.kde.dolphin.desktop";
      };
    };
}
