_: {
  flake.modules.nixos.b2 =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.services.b2;
      enabled = lib.filterAttrs (_: m: m.enable) cfg;

      mountPoint = name: "/mnt/b2/${name}";

      mountUnit =
        name:
        let
          stripped = lib.removePrefix "/" (mountPoint name);
        in
        "${builtins.replaceStrings [ "/" ] [ "-" ] stripped}.mount";

      mkService = name: m: {
        "b2-${name}" = {
          description = "B2 mount for ${name}";
          wants = [ "network-online.target" ];
          after = [
            "network-online.target"
            "sops-nix.service"
          ];
          wantedBy = [ "multi-user.target" ];

          script = ''
            cat > /run/b2/${name}.conf <<EOF
            [remote]
            type = b2
            account = $(cat ${m.accountIdFile})
            key = $(cat ${m.accountKeyFile})
            hard_delete = false
            EOF

            exec ${pkgs.rclone}/bin/rclone mount "remote:$(cat ${m.bucketFile})" ${mountPoint name} \
              --config /run/b2/${name}.conf \
              --allow-other \
              --default-permissions \
              --gid "$(${pkgs.coreutils}/bin/id -g ${m.group})" \
              --vfs-cache-mode writes \
              --dir-cache-time 12h \
              --cache-dir /var/cache/b2/${name} \
              --umask 0007 \
              --log-level INFO
          '';

          serviceConfig = {
            Type = "notify";
            User = "b2";
            Group = "b2";
            AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
            ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${mountPoint name}";
            Restart = "on-failure";
            RestartSec = "5s";
            LimitNOFILE = 1048576;
          };
        };
      };

      mkDependentServices =
        name: m:
        let
          unit = mountUnit name;
        in
        lib.genAttrs m.dependentServices (_: {
          requires = [ unit ];
          after = [ unit ];
        });

    in
    {
      options.services.b2 = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                enable = lib.mkEnableOption "this B2 mount";
                mountPoint = lib.mkOption {
                  type = lib.types.str;
                  default = mountPoint name;
                  readOnly = true;
                  description = "Where this B2 bucket is mounted (always /mnt/b2/<name>)";
                };
                accountIdFile = lib.mkOption {
                  type = lib.types.path;
                  description = "Path to file containing the B2 account ID";
                };
                accountKeyFile = lib.mkOption {
                  type = lib.types.path;
                  description = "Path to file containing the B2 account key";
                };
                bucketFile = lib.mkOption {
                  type = lib.types.path;
                  description = "Path to file containing the B2 bucket name";
                };
                group = lib.mkOption {
                  type = lib.types.str;
                  description = "Group with access to the mount";
                };
                dependentServices = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  example = [
                    "immich-server"
                    "paperless"
                  ];
                  description = "Services that require this mount to be available";
                };
              };
            }
          )
        );
        default = { };
      };

      config = lib.mkIf (enabled != { }) {
        environment.etc."fuse.conf".text = "user_allow_other\n";

        users.groups.b2 = { };
        users.users.b2 = {
          isSystemUser = true;
          group = "b2";
        };

        systemd.tmpfiles.rules = [
          "d /run/b2 0700 b2 b2 - -"
          "d /mnt/b2 0755 root root - -"
        ]
        ++ (
          lib.mapAttrsToList (name: m: [
            "d ${mountPoint name} 0770 root ${m.group} - -"
            "d /var/cache/b2/${name} 0700 b2 b2 - -"
          ]) enabled
          |> lib.concatLists
        );

        systemd.services = lib.mkMerge (
          (lib.mapAttrsToList mkService enabled) ++ (lib.mapAttrsToList mkDependentServices enabled)
        );
      };
    };
}
