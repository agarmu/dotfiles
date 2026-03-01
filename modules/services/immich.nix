_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      immichPort = config.services.immich.port;
    in
    {
      services.immich = {
        enable = true;
        port = 7271;
        mediaLocation = "/mnt/immich";
      };
      sops.secrets."rclone/immich/remote" = {
        owner = "rclone";
        group = "rclone";
      };
      sops.secrets."rclone/immich/account" = {
        owner = "rclone";
        group = "rclone";
      };
      sops.secrets."rclone/immich/key" = {
        owner = "rclone";
        group = "rclone";
      };
      users.users.immich.extraGroups = [
        "video"
        "render"
      ];
      services.rclone.mounts.immich = {
        enable = true;
        accountIdFile = config.sops.secrets."rclone/immich/account".path;
        appKeyFile = config.sops.secrets."rclone/immich/key".path;
        bucketFile = config.sops.secrets."rclone/immich/remote".path;
        mountPoint = "/mnt/immich";
        group = "immich";
      };
      services.nginx.virtualHosts."immich.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString immichPort}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };
}
