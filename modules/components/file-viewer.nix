{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  flake.modules.nixos.gui = {
    services.gvfs.enable = true;
  };
}
