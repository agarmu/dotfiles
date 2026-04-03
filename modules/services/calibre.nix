_: {
  flake.modules.nixos.host-millet =
    { config, pkgs, ... }:
    {
      sops.secrets."rclone/calibre/remote" = { };
      sops.secrets."rclone/calibre/account" = { };
      sops.secrets."rclone/calibre/key" = { };

      environment.etc."fuse.conf".text = "user_allow_other\n";

      systemd.tmpfiles.rules = [
        "d /mnt/calibre 0755 root root - -"
        "d /var/lib/calibre-web 0755 root root - -"
        "d /run/calibre-rclone 0700 root root - -"
        "d /var/cache/calibre-rclone 0700 root root - -"
      ];

      systemd.services.calibre-rclone-mount = {
        description = "Rclone B2 mount for Calibre books";
        wants = [
          "network-online.target"
          "sops-nix.service"
        ];
        after = [
          "network-online.target"
          "sops-nix.service"
        ];
        wantedBy = [ "multi-user.target" ];

        script = ''
          cat > /run/calibre-rclone/rclone.conf << EOF
          [remote]
          type = b2
          account = $(cat ${config.sops.secrets."rclone/calibre/account".path})
          key = $(cat ${config.sops.secrets."rclone/calibre/key".path})
          hard_delete = false
          EOF

          exec ${pkgs.rclone}/bin/rclone mount \
            "remote:$(cat ${config.sops.secrets."rclone/calibre/remote".path})" \
            /mnt/calibre \
            --config /run/calibre-rclone/rclone.conf \
            --allow-other \
            --default-permissions \
            --vfs-cache-mode writes \
            --dir-cache-time 12h \
            --cache-dir /var/cache/calibre-rclone \
            --log-level INFO
        '';

        serviceConfig = {
          Type = "notify";
          ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u /mnt/calibre";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };

      virtualisation.oci-containers = {
        backend = "docker";
        containers."calibre-web-automated" = {
          image = "crocodilestick/calibre-web-automated:latest";
          volumes = [ "/var/lib/calibre-web:/config" ];
          extraOptions = [
            "--mount"
            "type=bind,source=/mnt/calibre,target=/books,bind-propagation=slave"
            "--publish"
            "127.0.0.1:8083:8083"
          ];
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "UTC";
          };
        };
      };

      systemd.services."docker-calibre-web-automated" = {
        requires = [ "calibre-rclone-mount.service" ];
        after = [ "calibre-rclone-mount.service" ];
      };

      services.nginx.virtualHosts."calibre.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8083";
          proxyWebsockets = true;
        };
      };
    };
}
