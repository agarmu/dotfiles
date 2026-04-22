{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ acpi ];
      services.upower.enable = true;
    };

  flake.modules.nixos.mobile = {
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };
  flake.modules.homeManager.mobile =
    { pkgs, ... }:
    {
      systemd.user.services.niri-refresh-rate = {
        Unit = {
          Description = "Adjust niri refresh rate based on battery state";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = lib.getExe (
            pkgs.writeShellApplication {
              name = "niri-refresh-rate";
              runtimeInputs = [ pkgs.upower ];
              text = ''
                BATTERY=/sys/class/power_supply/macsmc-battery

                set_refresh() {
                  local battery status
                  battery=$(< "$BATTERY/capacity")
                  status=$(< "$BATTERY/status")
                  if (( battery > 70 )) || { [[ $status == Charging || $status == Full ]] && (( battery > 25 )); }; then
                    niri msg output eDP-1 mode 3024x1964@120.000
                  else
                    niri msg output eDP-1 mode 3024x1964@60.000
                  fi
                }

                until niri msg version >/dev/null 2>&1; do sleep 1; done
                set_refresh
                upower --monitor | while read -r _; do set_refresh; done
              '';
            }
          );
          Restart = "on-failure";
        };
      };
    };
}
