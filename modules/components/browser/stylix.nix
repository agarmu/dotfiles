{
  flake.modules.homeManager.gui = {
    stylix.targets.firefox = {
      enable = true;
      firefoxGnomeTheme.enable = false;
      profileNames = [ "default" ];
    };
  };
}
