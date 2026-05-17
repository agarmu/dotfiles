{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.nautilus ];
      services.gvfs.enable = true;
      services.gnome.sushi.enable = true;
    };
}
