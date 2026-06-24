{
  flake.modules.homeManager.linuxGui =
    { ... }:
    {
      programs.waybar.settings.mainBar = {
        "custom/voxtype" = {
          exec = "voxtype status --follow --format json";
          return-type = "json";
          format = "{}";
          tooltip = true;
          on-click = "systemctl --user restart voxtype";
        };
      };
    };
}
