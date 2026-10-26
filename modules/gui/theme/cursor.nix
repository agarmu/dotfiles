{
  flake.modules.homeManager.linuxGui = {
    catppuccin.cursors.enable = true;
    home.pointerCursor = {
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
