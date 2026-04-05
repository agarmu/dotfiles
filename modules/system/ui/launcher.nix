_: {
  flake.modules.homeManager.nixosGui =
    { config, ... }:
    {
      stylix.targets.fuzzel.fonts.override = config.stylix.fonts.monospace;

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "alacritty -e";
            lines = 10;
            width = 40;
            icons-enabled = true;
          };
          border.radius = 8;
        };
      };
    };
}
