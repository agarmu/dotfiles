{ lib, ... }:
{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.niri.settings = {
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };
        screenshot-path = "~/Pictures/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      };

      systemd.user.services.clean-screenshots = {
        Unit.Description = "Clean up old screenshots";
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.findutils} %h/Pictures/screenshots -name 'Screenshot*' -mtime +5 -delete";
        };
      };

      systemd.user.timers.clean-screenshots = {
        Unit.Description = "Clean up old screenshots weekly";
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
