{
  flake.modules.homeManager.nixosGui =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      trashPut = lib.getExe' pkgs.trash-cli "trash-put";
      trashEmpty = lib.getExe' pkgs.trash-cli "trash-empty";
      du = lib.getExe' pkgs.coreutils "du";
      find = lib.getExe pkgs.findutils;
      notify = lib.getExe pkgs.libnotify;
      df = lib.getExe' pkgs.coreutils "df";
      date = lib.getExe' pkgs.coreutils "date";
      git = lib.getExe config.programs.git.package;

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
      (mkService
        {
          name = "notify-downloads";
          description = "Notify about old files in Downloads";
          trigger.timer = "weekly";
        }
        ''
          set -euo pipefail
          dir="$HOME/Downloads"
          [ -d "$dir" ] || exit 0
          count=$(${find} "$dir" -maxdepth 1 -mtime +30 -print | wc -l)
          echo "Old downloads: $count"
          if [ "$count" -gt 0 ]; then
            ${notify} "Downloads" "$count file(s) older than 30 days — consider cleaning up ~/Downloads"
          fi
        ''
      )

      (mkService
        {
          name = "notify-disk-usage";
          description = "Notify if home partition is over 90% full";
          trigger.timer = "*:0/6";
        }
        ''
          set -euo pipefail
          usage=$(${df} --output=pcent "$HOME" | tail -1 | tr -d ' %')
          echo "Home partition usage: ''${usage}%"
          if [ "$usage" -gt 90 ]; then
            ${notify} "Disk Space" "Home partition is ''${usage}% full"
          fi
        ''
      )

      (mkService
        {
          name = "clean-thumbnail-cache";
          description = "Remove old thumbnails from cache";
          trigger.timer = "weekly";
        }
        ''
          set -euo pipefail
          dir="$HOME/.cache/thumbnails"
          [ -d "$dir" ] || exit 0
          count=0
          while IFS= read -r -d "" f; do
            echo "Trashing: $f"
            ${trashPut} "$f"
            count=$((count + 1))
          done < <(${find} "$dir" -type f -mtime +14 -print0)
          echo "Trashed $count thumbnail(s)"
        ''
      )
      (mkService
        {
          name = "clean-direnv-cache";
          description = "Remove stale .direnv directories";
          trigger.timer = "daily";
        }
        ''
          set -euo pipefail
          cutoff=$(( $(${date} +%s) - 7 * 86400 ))
          count=0
          while IFS= read -r -d "" d; do
            project="''${d%/.direnv}"
            recent_files=$(${find} "$project" -maxdepth 1 \
              -newer "$d" -not -name ".direnv" | wc -l)
            last_commit=$(${git} -C "$project" log -1 --format="%at" 2>/dev/null || echo 0)
            if [ "$recent_files" -eq 0 ] && [ "$last_commit" -lt "$cutoff" ]; then
              echo "Removing stale .direnv: $project"
              rm -rf "$d"
              count=$((count + 1))
            fi
          done < <(${find} "$HOME" -maxdepth 5 -name ".direnv" -type d -print0)
          echo "Removed $count stale .direnv directories"
        ''
      )

      (mkService
        {
          name = "posture-reminder";
          description = "Periodic posture reminder";
          trigger.timer = "*:0/30";
        }
        ''
          ${notify} -u low "Posture check" "Sit up straight and relax your shoulders"
        ''
      )
    ];
}
