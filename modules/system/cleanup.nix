_: {
  flake.modules.homeManager.nixosGui =
    { lib, pkgs, ... }:
    let
      trashPut = lib.getExe' pkgs.trash-cli "trash-put";
      trashEmpty = lib.getExe' pkgs.trash-cli "trash-empty";
      du = lib.getExe' pkgs.coreutils "du";
      find = lib.getExe pkgs.findutils;
      notify = lib.getExe pkgs.libnotify;

      mkService =
        {
          name,
          description,
          trigger,
        }:
        script:
        let
          triggerUnit =
            if trigger ? timer then
              {
                systemd.user.timers.${name} = {
                  Unit.Description = "${description} (timer)";
                  Timer = {
                    OnCalendar = trigger.timer;
                    Persistent = true;
                    RandomizedDelaySec = "30min";
                  };
                  Install.WantedBy = [ "timers.target" ];
                };
              }
            else
              {
                systemd.user.paths.${name} = {
                  Unit.Description = "${description} (path watcher)";
                  Path = {
                    PathChanged = trigger.path;
                    MakeDirectory = true;
                  };
                  Install.WantedBy = [ "default.target" ];
                };
              };
        in
        lib.mkMerge [
          {
            systemd.user.services.${name} = {
              Unit.Description = description;
              Service = {
                Type = "oneshot";
                ExecStart = toString (pkgs.writeShellScript name script);
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "5min";
              };
            };
          }
          triggerUnit
        ]
        |> builtins.seq (
          lib.assertMsg (
            (trigger ? timer) != (trigger ? path)
          ) "mkService '${name}': specify exactly one of trigger.timer or trigger.path"
        );
    in
    lib.mkMerge [
      (mkService
        {
          name = "trash-screenshots";
          description = "Move old screenshots to trash";
          trigger.timer = "daily";
        }
        ''
          set -euo pipefail
          dir="$HOME/Pictures/screenshots"
          [ -d "$dir" ] || exit 0
          count=0
          while IFS= read -r -d "" f; do
            echo "Trashing: $f"
            ${trashPut} "$f"
            count=$((count + 1))
          done < <(${find} "$dir" -name 'Screenshot*' -mmin +1440 -print0)
          echo "Trashed $count screenshot(s)"
        ''
      )

      (mkService
        {
          name = "trash-downloads";
          description = "Move old downloads to trash";
          trigger.timer = "weekly";
        }
        ''
          set -euo pipefail
          dir="$HOME/Downloads"
          [ -d "$dir" ] || exit 0
          count=0
          while IFS= read -r -d "" f; do
            echo "Trashing: $f"
            ${trashPut} "$f"
            count=$((count + 1))
          done < <(${find} "$dir" -maxdepth 1 -mtime +30 -print0)
          echo "Trashed $count download(s)"
        ''
      )

      (mkService
        {
          name = "notify-trash-size";
          description = "Notify if trash exceeds 1 GB";
          trigger.path = "%h/.local/share/Trash/files";
        }
        ''
          set -euo pipefail
          trash_dir="$HOME/.local/share/Trash/files"
          [ -d "$trash_dir" ] || exit 0
          size=$(${du} -sb "$trash_dir" | cut -f1)
          echo "Trash size: $size bytes"
          if [ "$size" -gt $((1024 * 1024 * 1024)) ]; then
            size_hr=$(${du} -sh "$trash_dir" | cut -f1)
            ${notify} "Trash" "Trash is ''${size_hr} — consider emptying it"
          fi
        ''
      )

      (mkService
        {
          name = "empty-trash";
          description = "Remove old files from trash";
          trigger.timer = "daily";
        }
        ''
          set -euo pipefail
          trash_dir="$HOME/.local/share/Trash/files"
          [ -d "$trash_dir" ] || exit 0
          size=$(${du} -sb "$trash_dir" | cut -f1)
          echo "Trash size: $size bytes"
          if [ "$size" -gt $((1024 * 1024 * 1024)) ]; then
            echo "Trash > 1 GB — removing files older than 30 days"
            ${trashEmpty} 30
          else
            echo "Trash <= 1 GB — removing files older than 7 days"
            ${trashEmpty} 7
          fi
        ''
      )
    ];
}
