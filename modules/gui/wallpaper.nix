{ lib, ... }:
{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.awww ];
      systemd.user.services.awww-daemon = {
        Unit = {
          Description = "Animated wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe' pkgs.awww "awww-daemon"} -l background";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.desktoppr ];
  };
}
