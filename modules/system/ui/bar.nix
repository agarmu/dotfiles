_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      stylix.targets.waybar.enable = false;

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          margin-top = 6;
          margin-left = 8;
          margin-right = 8;
          spacing = 4;

          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-right = [
            "clock"
            "custom/notification"
            "group/system"
          ];

          "niri/workspaces" = {
            format = "";
            current-only = false;
          };

          "niri/window" = {
            format = "{}";
            max-length = 40;
            rewrite = {
              "" = " ";
            };
          };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              weeks-pos = "left";
              on-scroll = 1;
              format = {
                months = "<span color='#cad3f5'><b>{}</b></span>";
                days = "<span color='#a5adcb'>{}</span>";
                weeks = "<span color='#6e738d'>W{}</span>";
                weekdays = "<span color='#8aadf4'><b>{}</b></span>";
                today = "<span color='#eed49f'><b><u>{}</u></b></span>";
              };
            };
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "󰂚";
              none = "󰂜";
              dnd-notification = "󰂛";
              dnd-none = "󰪑";
              inhibited-notification = "󰂚";
              inhibited-none = "󰂜";
              dnd-inhibited-notification = "󰂛";
              dnd-inhibited-none = "󰪑";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          "group/system" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
              children-class = "system-drawer";
            };
            modules = [
              "custom/system-icon"
              "pulseaudio"
              "backlight"
              "battery"
              "custom/network"
              "custom/bluetooth"
              "custom/airplane"
            ];
          };

          "custom/system-icon" = {
            format = "󰒓";
            tooltip = false;
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 muted";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
            tooltip-format = "{desc}";
          };

          backlight = {
            format = "󰃠 {percent}%";
            on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
            on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            tooltip = false;
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            tooltip-format = "{timeTo}";
          };

          "custom/network" = {
            format = "{}";
            exec = pkgs.writeShellScript "waybar-network" ''
              wifi_status=$(${pkgs.networkmanager}/bin/nmcli radio wifi)
              if [ "$wifi_status" = "enabled" ]; then
                ssid=$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
                if [ -n "$ssid" ]; then
                  echo "󰤨 $ssid"
                else
                  echo "󰤭 none"
                fi
              else
                echo "󰤮 off"
              fi
            '';
            interval = 10;
            on-click = "${pkgs.networkmanager}/bin/nmcli radio wifi $(${pkgs.networkmanager}/bin/nmcli radio wifi | grep -q enabled && echo off || echo on)";
            tooltip = false;
          };

          "custom/bluetooth" = {
            format = "{}";
            exec = pkgs.writeShellScript "waybar-bluetooth" ''
              status=$(${pkgs.bluez}/bin/bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}')
              if [ "$status" = "yes" ]; then
                echo "󰂯 on"
              else
                echo "󰂲 off"
              fi
            '';
            interval = 10;
            on-click = pkgs.writeShellScript "waybar-bluetooth-toggle" ''
              status=$(${pkgs.bluez}/bin/bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}')
              if [ "$status" = "yes" ]; then
                ${pkgs.bluez}/bin/bluetoothctl power off
              else
                ${pkgs.bluez}/bin/bluetoothctl power on
              fi
            '';
            tooltip = false;
          };

          "custom/airplane" = {
            format = "{}";
            exec = pkgs.writeShellScript "waybar-airplane" ''
              blocked=$(${pkgs.util-linux}/bin/rfkill list all 2>/dev/null | grep -c 'Soft blocked: yes')
              if [ "$blocked" -gt 0 ]; then
                echo "󰀝 on"
              else
                echo "󰀞 off"
              fi
            '';
            interval = 10;
            on-click = pkgs.writeShellScript "waybar-airplane-toggle" ''
              blocked=$(${pkgs.util-linux}/bin/rfkill list all 2>/dev/null | grep -c 'Soft blocked: yes')
              if [ "$blocked" -gt 0 ]; then
                ${pkgs.util-linux}/bin/rfkill unblock all
              else
                ${pkgs.util-linux}/bin/rfkill block all
              fi
            '';
            tooltip = false;
          };
        };

        style = ''
          * {
            font-family: "Lilex Nerd Font", "Source Sans 3", monospace;
            font-size: 14px;
            min-height: 0;
          }

          window#waybar {
            background: rgba(36, 39, 58, 0.85);
            border-radius: 12px;
            color: #cad3f5;
          }

          tooltip {
            background: #363a4f;
            border: 1px solid #494d64;
            border-radius: 8px;
            color: #cad3f5;
          }

          #workspaces {
            margin: 4px 4px 4px 8px;
          }

          #workspaces button {
            color: #6e738d;
            padding: 0 6px;
            border-radius: 50%;
            min-width: 12px;
            min-height: 12px;
            margin: 4px 2px;
            background: #494d64;
          }

          #workspaces button.active {
            background: #8aadf4;
            color: #24273a;
          }

          #workspaces button:hover {
            background: #5b6078;
          }

          #window {
            color: #a5adcb;
            padding: 0 8px;
          }

          #clock {
            color: #cad3f5;
            font-weight: bold;
            padding: 0 12px;
          }

          #custom-notification {
            color: #8aadf4;
            padding: 0 12px;
          }

          #custom-system-icon {
            color: #cad3f5;
            padding: 0 8px 0 12px;
            font-size: 16px;
          }

          .system-drawer {
            padding: 0 4px;
            transition: all 300ms ease;
          }

          #pulseaudio {
            color: #8aadf4;
            padding: 0 8px;
          }

          #pulseaudio.muted {
            color: #6e738d;
          }

          #backlight {
            color: #eed49f;
            padding: 0 8px;
          }

          #battery {
            color: #a6da95;
            padding: 0 8px;
          }

          #battery.warning {
            color: #f5a97f;
          }

          #battery.critical {
            color: #ed8796;
            animation: blink 1s linear infinite;
          }

          @keyframes blink {
            to {
              color: transparent;
            }
          }

          #custom-network {
            color: #8bd5ca;
            padding: 0 8px;
          }

          #custom-bluetooth {
            color: #8aadf4;
            padding: 0 8px;
          }

          #custom-airplane {
            color: #f5a97f;
            padding: 0 8px 0 4px;
          }
        '';
      };
    };
}
