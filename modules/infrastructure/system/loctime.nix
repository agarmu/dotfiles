{ lib, ... }: {
  flake.modules.nixos.base = {
    time.timeZone = lib.mkDefault "America/New_York";
    services.automatic-timezoned.enable = true;
  };

  flake.modules.nixos.mobile = {
    location.provider = "geoclue2";
    services.geoclue2 = {
      enable = true;
    };

    systemd.services.automatic-timezoned = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      # Allow up to 20 restarts before systemd gives up entirely
      startLimitBurst = 20;
      # Reset the failure counter if the service manages to stay up for 5 minutes
      startLimitIntervalSec = 300;

      serviceConfig = {
        Restart = "on-failure";

        # Start by waiting 2 seconds on the first failure
        RestartSec = "2s";
        # Double the wait time on each subsequent failure, capping it at 30 seconds
        RestartSteps = 2;
        RestartMaxDelaySec = "30s";
      };
    };
  };

  flake.modules.homeManager.mobile = { pkgs, ... }: {
    systemd.user.paths.watch-timezone = {
      # Fix: Wrap Description inside the Unit attribute set
      Unit = {
        Description = "Watch /etc/localtime for timezone changes";
      };

      Path = {
        PathChanged = "/etc/localtime";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.watch-timezone = {
      Unit = {
        Description = "Reload Waybar on timezone change";
        After = [ "watch-timezone.path" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl --user reload waybar.service";
      };
    };
  };
}
