_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      gtk.iconTheme = {
        package = pkgs.nordzy-icon-theme;
        name = "Nordzy-dark";
      };
    };
}
