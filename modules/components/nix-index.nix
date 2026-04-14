_: {
  flake.modules.homeManager.base =
    {
      lib,
      config,
      ...
    }:
    {
      programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      systemd.user.services.nix-index-regenerate = {
        Unit.Description = "Regenerate nix-index database";
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe config.programs.nix-index.package;
        };
      };

      systemd.user.timers.nix-index-regenerate = {
        Unit.Description = "Regenerate nix-index database weekly";
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
          RandomizedDelaySec = "1h";
          Unit = "nix-index-regenerate.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };

    };
}
