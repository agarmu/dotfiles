{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };
}
