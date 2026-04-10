{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.wleave ];

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
            timeout = 30;
            command = "${lib.getExe pkgs.swaylock}";
          }
          {
            timeout = 90;
            command = "${lib.getExe config.programs.niri.package} msg action power-off-monitors";
          }
        ];
      };
    };
}
