{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.gnome-shell.enable = true;
      home.packages = with pkgs; [
        nautilus
        gnome-disk-utility
      ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
}
