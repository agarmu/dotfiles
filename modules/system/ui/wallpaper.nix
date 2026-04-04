{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ awww ];

      systemd.user.services.awww-daemon = {
        Unit = {
          Description = "Animated wallpaper daemon";
          BindsTo = [ "niri.service" ];
          After = [ "niri.service" ];
        };
        Service = {
          ExecStart = "${lib.getExe' pkgs.awww "awww-daemon"} -l background";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };

      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        layout.background-color = "transparent";
        layer-rules = [
          {
            matches = [
              { namespace = "^awww.*$"; }
            ];
            place-within-backdrop = true;
          }
        ];
      };
    };
}
