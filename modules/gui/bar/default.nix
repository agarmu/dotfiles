{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
      systemd.user.services.waybar = {
        Unit = {
          BindsTo = [ "niri.service" ];
          After = [ "niri.service" ];
        };
      };

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;

          modules-left = [
            "custom/voxtype"
            "niri/workspaces"
            "niri/window"
          ];
          modules-center = [ ];
          modules-right = [
            "idle_inhibitor"
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
