{ lib, ... }:
{
  flake.modules.nixos.gui = {
    security.pam.services.hyprlock = { };
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    let
      lockCmd = lib.getExe config.programs.hyprlock.package;
      niriCmd = lib.getExe config.programs.niri.package;
      notifySend = lib.getExe' pkgs.libnotify "notify-send";
    in
    {
      home.packages = [ pkgs.wleave ];

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
          };

          label = {
            text = "cmd[update:1000] date +'%H:%M'";
            font_size = 72 * 4;
            font_family = config.stylix.fonts.monospace.name;
            position = "0, 300";
            halign = "center";
            valign = "center";
          };

          input-field = {
            size = "560, 112";
            position = "0, -192";
            halign = "center";
            valign = "center";
            dots_center = true;
            fade_on_empty = false;
            outline_thickness = 2;
            placeholder_text = "Password...";
          };
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = lockCmd;
            before_sleep_cmd = lockCmd;
          };

          listener = [
            {
              timeout = 60 * 3;
              on-timeout = ''${notifySend} --urgency=normal "Locking in 30 seconds" "Session will lock after 30 more seconds of inactivity."'';
            }
            {
              timeout = 60 * 3 + 30;
              on-timeout = lockCmd;
            }
            {
              timeout = 60 * 5;
              on-timeout = "${niriCmd} msg action power-off-monitors";
              on-resume = "${niriCmd} msg action power-on-monitors";
            }
            {
              timeout = 60 * 10;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
}
