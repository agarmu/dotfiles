{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
      systemd.user.services.waybar = {
        Unit = {
          PartOf = [ "graphical-session.target" ];
          After = [
            "graphical-session.target"
            "niri.service"
          ];
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
