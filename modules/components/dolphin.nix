_: {
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kdePackages.dolphin ];
    };
  flake.modules.homeManager.gui = _: {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };
  };
}
