{ lib, ... }:

{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.networkmanagerapplet ];

      systemd.user.services.nm-applet = {
        Unit = {
          Description = "NetworkManager applet tray icon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe' pkgs.networkmanagerapplet "nm-applet"}";
          Restart = "on-failure";
          RestartSec = "2s";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
