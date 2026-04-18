{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    let
      inherit (config.lib.stylix) colors;
      lockCmd = lib.getExe config.programs.swaylock.package;
      notifySend = lib.getExe' pkgs.libnotify "notify-send";
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

      # swaylock
      programs.swaylock = {
        enable = true;
        settings = {
          show-failed-attempts = true;
          daemonize = true;
          scaling = "fill";
        };
      };

      # swayidle: lock at 30s idle, power off monitors at 90s
      services.swayidle = {
        enable = true;
        events = {
          before-sleep = "${lib.getExe pkgs.swaylock}";
        };
        timeouts = [
          {
            timeout = 60 * 3;
            command = "${lib.getExe pkgs.swaylock}";
          }
          {
            timeout = 60 * 5;
            command = "niri msg action power-off-monitors";
          }
        ];
      };
    };
}
