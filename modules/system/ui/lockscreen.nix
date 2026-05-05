{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      programs.wlogout = {
        enable = true;
        style = ''
          * {
            background-image: none;
            box-shadow: none;
            font-family: "${config.stylix.fonts.sansSerif.name}";
          }

          window {
            background-color: #${colors.base00};
          }

          button {
            margin: 24px;
            padding: 32px;
            border-radius: 24px;
            border: 2px solid #${colors.base03};
            background-color: #${colors.base01};
            color: #${colors.base07};
            font-size: ${toString (config.stylix.fonts.sizes.desktop * 2)}px;
          }

          button:hover,
          button:focus {
            background-color: #${colors.base0D};
            color: #${colors.base00};
            border-color: #${colors.base0D};
          }
        '';
      };

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
          };
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "${lib.getExe pkgs.hyprlock}";
            before_sleep_cmd = "${lib.getExe pkgs.hyprlock}";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 180;
              on-timeout = "notify-send -e -t 2000 'Screen Lock' 'Locking in 20 seconds...'";
            }
            {
              timeout = 200;
              on-timeout = "${lib.getExe pkgs.hyprlock}";
            }
            {
              timeout = 300;
              on-timeout = "niri msg action power-off-monitors";
              on-resume = "niri msg action power-on-monitors";
            }
          ];
        };
      };
    };
}
