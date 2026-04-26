{ lib, ... }:

{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:

    {
      systemd.user.services.niri-tile-to-n = {
        Unit = {
          Description = "Tile windows up to N columns before scrolling";
          BindsTo = [ "niri.service" ];
          After = [ "niri.service" ];
        };
        Service = {
          ExecStart = "${lib.getExe' pkgs.mukul.niri-tweaks "niri_tile_to_n"} -n 3 -m";
          Restart = "on-failure";
          RestartSec = "2s";
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };
}
