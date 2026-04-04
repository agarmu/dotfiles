_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      gtk.iconTheme = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "macchiato";
          accent = "mauve";
        };
        name = "Papirus-Dark";
      };
    };
}
