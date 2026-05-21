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
