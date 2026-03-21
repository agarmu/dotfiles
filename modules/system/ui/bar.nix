{ lib, ... }:
let
  icons = rec {
    calendar = "󰃭 ";
    clock = " ";
    battery.charging = "󱐋";
    battery.vertical = [
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
    battery.levels = battery.vertical;
    network.disconnected = "󰤮 ";
    network.ethernet = "󰈀 ";
    network.strength = [
      "󰤟 "
      "󰤢 "
      "󰤥 "
      "󰤨 "
    ];
    bluetooth.on = "󰂯";
    bluetooth.off = "󰂲";
    bluetooth.battery = "󰥉";
    volume.source = "󱄠";
    volume.muted = "󰝟";
    volume.levels = [
      "󰕿"
      "󰖀"
      "󰕾"
    ];
    idle.on = "󰈈 ";
    idle.off = "󰈉 ";
    notification.bell = "󰂚";
    notification.bell-outline = "󰂜";
  };
in
{
  flake.modules.homeManager.nixosGui =
    { config, pkgs, ... }:
    {
      stylix.targets.waybar.enable = false;

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;

          modules-left = [
            "wireplumber"
            "idle_inhibitor"
          ];
          modules-center = [
          ];
          modules-right = [
            "network"
            "bluetooth"
            "bluetooth#battery"
            "battery"
            "clock#date"
            "clock"
            "custom/swaync"
          ];

          wireplumber = {
            format = "{icon} {volume}%";
            format-muted = "${icons.volume.muted} muted";
            format-icons = icons.volume.levels;
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
            tooltip-format = "{node_name}";
          };

          "wireplumber#source" = {
            format = "${icons.volume.source} {volume}%";
            format-muted = "${icons.volume.source} muted";
            tooltip-format = "{node_name}";
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = icons.idle.on;
              deactivated = icons.idle.off;
            };
            tooltip-format-activated = "Idle inhibitor: on";
            tooltip-format-deactivated = "Idle inhibitor: off";
          };

          "clock#date" = {
            format = "${icons.calendar}{:%a %b %d}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              weeks-pos = "left";
              on-scroll = 1;
            };
          };

          clock = {
            format = "${icons.clock}{:%H:%M}";
            tooltip-format = "{:%A, %B %d %Y %H:%M:%S}";
          };

          network = {
            format-wifi = "{icon} {essid}";
            format-ethernet = "${icons.network.ethernet}{ifname}";
            format-disconnected = icons.network.disconnected;
            format-icons = icons.network.strength;
            tooltip-format = "{ipaddr}/{cidr}";
          };

          bluetooth = {
            format = "${icons.bluetooth.on}";
            format-disabled = "${icons.bluetooth.off}";
            format-connected = "${icons.bluetooth.on} {num_connections}";
            tooltip-format = "{controller_alias}\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}";
          };

          "bluetooth#battery" = {
            format = "${icons.bluetooth.battery} {device_battery_percentage}%";
            format-disabled = "";
            format-connected = "${icons.bluetooth.battery} {device_battery_percentage}%";
            tooltip-format = "{device_alias}: {device_battery_percentage}%";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "${icons.battery.charging}{icon} {capacity}%";
            format-plugged = "${icons.battery.charging}{icon} {capacity}%";
            format-icons = icons.battery.levels;
            tooltip-format = "{timeTo}";
          };

          "custom/swaync" = {
            tooltip = false;
            format = "{icon} {text}";
            format-icons = {
              notification = icons.notification.bell;
              none = icons.notification.bell-outline;
              dnd-notification = "󰂛";
              dnd-none = "󰪑";
              inhibited-notification = icons.notification.bell;
              inhibited-none = icons.notification.bell-outline;
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
        };

        style =
          let
            colors = config.lib.stylix.colors;
            modules = s: "${s ".modules-left"}, ${s ".modules-center"}, ${s ".modules-right"}";
            module = s: modules (m: "${m} > ${s} > *");
          in
          ''
            * {
              border: none;
              font-family: "${config.stylix.fonts.sansSerif.name}";
              font-size: ${toString config.stylix.fonts.sizes.desktop}px;
              color: #${colors.base07};
            }
            window#waybar {
              background: transparent;
              font-size: 2em;
            }
            ${modules lib.id} {
              background: transparent;
              margin: 3px 10px;
            }
            ${module "*"} {
              margin: 3px 1px;
              padding: 5px 7px;
              background: #${colors.base00};
            }
            ${module ":first-child"} {
              padding-left: 10px;
              border-top-left-radius: 20px;
              border-bottom-left-radius: 20px;
            }
            ${module ":last-child"} {
              padding-right: 10px;
              border-top-right-radius: 20px;
              border-bottom-right-radius: 20px;
            }
            ${module ":not(:first-child)"} {
              border-top-left-radius: 3px;
              border-bottom-left-radius: 3px;
            }
            ${module ":not(:last-child)"} {
              border-top-right-radius: 3px;
              border-bottom-right-radius: 3px;
            }
            #wireplumber:not(.source).muted { color: #${colors.base0A}; }
            #idle_inhibitor.activated { color: #${colors.base0A}; }
            #battery.charging { color: #${colors.base0B}; }
            #battery.warning:not(.charging) { color: #${colors.base0A}; }
            #battery.critical:not(.charging) {
              animation: critical-blink steps(8) 1s infinite alternate;
            }
            @keyframes critical-blink { to { color: #${colors.base08}; } }
          '';
      };
    };
}
