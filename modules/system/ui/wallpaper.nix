_: {
  flake.modules.homeManager.nixosGui = {
    programs.noctalia-shell.settings.wallpaper = {
      enabled = true;
      directory = "~/Pictures/wallpapers";
    };
  };
}
