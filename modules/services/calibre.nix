_: {
  flake.modules.nixos.host-millet = _: {
    systemd.tmpfiles.rules = [
      "d /var/lib/calibre-web 0755 root root - -"
      "d /var/lib/calibre/library 0755 root root - -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers."calibre-web-automated" = {
        image = "crocodilestick/calibre-web-automated:latest";
        extraOptions = [
          "--mount"
          "type=bind,source=/var/lib/calibre-web,target=/config"
          "--mount"
          "type=bind,source=/var/lib/calibre/library,target=/calibre-library,bind-propagation=slave"
          "--publish"
          "127.0.0.1:8083:8083"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "America/New_York";
          NETWORK_SHARE_MODE = "false";
        };
      };
    };

    systemd.services."docker-calibre-web-automated" = {
      requires = [ "calibre-rclone-mount.service" ];
      after = [ "calibre-rclone-mount.service" ];
    };

    services.caddy.virtualHosts."calibre.agarmu.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8083
      '';
    };
  };
}
