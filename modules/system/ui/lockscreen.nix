{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.mukul.blurlock ];

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
          before-sleep = "blurlock";
        };
        timeouts = [
          {
            timeout = 30;
            command = "blurlock";
          }
          {
            timeout = 90;
            command = "${lib.getExe config.programs.niri.package} msg action power-off-monitors";
          }
        ];
      };
    };
}
