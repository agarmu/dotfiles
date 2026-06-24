{
  flake.modules.homeManager.linuxGui =
    { ... }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;

          modules-left = [
            "niri/workspaces"
            "idle_inhibitor"
          ];
          modules-center = [ ];
          modules-right = [
            "systemd-failed-units"
            "cpu"
            "memory"
            "temperature"
            "battery"
            "clock"
            "tray"
          ];
        };
      };
    };
}
