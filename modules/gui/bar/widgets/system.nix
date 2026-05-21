{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
      programs.waybar.settings.mainBar = {
        systemd-failed-units = {
          hide-on-ok = true;
          format = "✗ {nr_failed}";
          system = true;
          user = true;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰈈 ";
            deactivated = "󰈉 ";
          };
          tooltip-format-activated = "Idle inhibited";
          tooltip-format-deactivated = "Idle allowed";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "󰂄";
          format-plugged = "";
          tooltip-format = "{capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        clock = {
          format = "{:%H:%M}";
          tooltip = false;
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% 󰍛";
        };

        temperature = {
          critical-threshold = 60;
          format = "{icon}";
          tooltip = true;
          tooltip-format = "{temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
        };
      };
    };
}
