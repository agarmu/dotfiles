_: {
  flake.modules.homeManager.base =
    {
      pkgs,
      lib,
      ...
    }:
    let
      package = pkgs.nix-search;
    in
    {
      home.packages = [ package ];

      systemd.user.services.nix-search-regenerate = {
        Unit.Description = "Regenerate nix-search database";
        Service = {
          Type = "oneshot";
          # only regenerate the index
          ExecStart = "${lib.getExe package} --index --max-jobs 2";
        };
      };

      systemd.user.timers.nix-search-regenerate = {
        Unit.Description = "Regenerate nix-search database weekly";
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
          RandomizedDelaySec = "1h";
          Unit = "nix-search-regenerate.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };

    };
}
