{ lib, ... }:
{
  flake.modules.nixos.gui = {
    programs.hyprlock.enable = true;
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    {
      stylix.targets.hyprlock.enable = false;

      programs.hyprlock = {
        enable = true;
        settings = {
          "$font" = config.stylix.fonts.monospace.name;
          background = {
            path = "/etc/wallpaper.jpg";
            blur_passes = 3;
          };

          general = {
            hide_cursor = false;
          };

          animations = {
            enabled = true;
            bezier = "linear, 1, 1, 0, 0";
            animation = [
              "fadeIn, 1, 5, linear"
              "fadeOut, 1, 5, linear"
              "inputFieldDots, 1, 2, linear"
            ];
          };

          input-field = {
            size = "20%, 5%";
            outline_thickness = 3;
            inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

            outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
            fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

            font_color = "rgb(ffffff)";
            font_family = "$font";
            fade_on_empty = false;
            rounding = 15;

            placeholder_text = "Input password...";
            fail_text = "$PAMFAIL";

            dots_spacing = 0.3;

            position = "0, -20";
            halign = "center";
            valign = "center";
          };
          label = [
            {
              text = "$TIME";
              font_family = "$font";
              font_size = 50;
              position = "-60, -60";
              halign = "right";
              valign = "top";
            }
            {
              text = "cmd[update:60000] date +'%a, %Y/%m/%d'";
              font_family = "$font";
              font_size = 50;
              position = "60, -60";
              halign = "left";
              valign = "top";
            }
          ];
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
