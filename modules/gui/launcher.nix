{
  flake.modules.homeManager.linuxGui =
    { config, ... }:
    {
      /*
        by default fuzzel uses the sans font,
        but we want monospace
      */
      stylix.targets.fuzzel.fonts.override = {
        sansSerif = config.stylix.fonts.monospace;
      };

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "ghostty -e";
            lines = 10;
            width = 40;
            icons-enabled = true;
          };
          border.radius = 8;
        };
      };
    };
}
