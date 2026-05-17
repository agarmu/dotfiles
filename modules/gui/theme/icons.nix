{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      gtk.iconTheme = {
        package = pkgs.colloid-icon-theme;
        name = "Colloid";
      };
    };
}
