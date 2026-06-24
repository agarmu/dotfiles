{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      gtk.iconTheme = {
        package = pkgs.colloid-icon-theme;
        name = "Colloid";
      };
    };
}
