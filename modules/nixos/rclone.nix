_: {
  flake.modules.nixos.rclone =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.services.rclone;
      enabled = lib.filterAttrs (_: m: m.enable) cfg.mounts;

      mkService =
        name: m:
        let
          group = config.users.groups.${m.group};
        in
        {
          "rclone-mount-${name}" = {
            description = "rclone mount ${name}";
            wants = [ "network-online.target" ];
            after = [
              "network-online.target"
              "sops-nix.service"
            ];
            wantedBy = [ "multi-user.target" ];

            script = ''
              cat > /run/rclone/${name}.conf <<EOF
              [remote]
              type = b2
              account = $(cat ${m.accountIdFile})
              key = $(cat ${m.appKeyFile})
              bucket = $(cat ${m.bucketFile})
              hard_delete = false
              EOF

              exec ${pkgs.rclone}/bin/rclone mount remote: ${m.mountPoint} \
                --config /run/rclone/${name}.conf \
                --allow-other \
                --gid ${toString group.gid} \
                --vfs-cache-mode writes \
                --dir-cache-time 12h \
                --poll-interval 1m \
                --cache-dir /var/cache/rclone/${name} \
                --umask 0007 \
                --log-level INFO
            '';

            serviceConfig = {
              Type = "notify";
              User = "rclone";
              Group = "rclone";
              ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${m.mountPoint}";
              Restart = "on-failure";
              RestartSec = "5s";
              LimitNOFILE = 1048576;
            };
          };
        };

    in
    {
      options.services.rclone.mounts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "this mount";
              accountIdFile = lib.mkOption { type = lib.types.path; };
              appKeyFile = lib.mkOption { type = lib.types.path; };
              bucketFile = lib.mkOption { type = lib.types.path; };
              mountPoint = lib.mkOption { type = lib.types.str; };
              group = lib.mkOption { type = lib.types.str; };
            };
          }
        );
        default = { };
      };

      config = lib.mkIf (enabled != { }) {
        environment.etc."fuse.conf".text = "user_allow_other\n";

        users.groups.rclone = { };
        users.users.rclone = {
          isSystemUser = true;
          group = "rclone";
        };

        systemd.tmpfiles.rules = [
          "d /run/rclone 0700 rclone rclone - -"
        ]
        ++ (
          lib.mapAttrsToList (name: m: [
            "d ${m.mountPoint} 0770 root ${m.group} - -"
            "d /var/cache/rclone/${name} 0700 rclone rclone - -"
          ]) enabled
          |> lib.concatLists
        );

        systemd.services = lib.mapAttrsToList mkService enabled |> lib.mkMerge;
      };
    };
}
