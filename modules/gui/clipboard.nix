{
  flake.modules.homeManager.linuxGui =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
        clipvault
      ];
      systemd.user.services.clipvault = {
        Unit = {
          Description = "Clipboard history manager";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.clipvault} store --max-entry-age 24h";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
