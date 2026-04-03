_: {
  flake.modules.homeManager.nixosGui =
    { lib, pkgs, ... }:
    {
      systemd.user.services.notify-old-downloads = {
        Unit.Description = "Notify about old files in Downloads";
        Service = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "notify-old-downloads" ''
              count=$(${lib.getExe pkgs.findutils} "$HOME/Downloads" -maxdepth 1 -mtime +30 | wc -l)
              if [ "$count" -gt 0 ]; then
                ${lib.getExe pkgs.libnotify} "Downloads" "$count files older than 30 days — consider cleaning up ~/Downloads"
              fi
            ''
          );
        };
      };

      systemd.user.timers.notify-old-downloads = {
        Unit.Description = "Notify about old downloads weekly";
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
