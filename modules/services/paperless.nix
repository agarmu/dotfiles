_: {
  flake.modules.nixos.host-millet =
    { pkgs, config, ... }:
    {
      services.paperless = {
        enable = true;
        consumptionDirIsPublic = true;
        passwordFile = config.sops.secrets."paperless-admin-password".path;
        settings = {
          PAPERLESS_URL = "https://paperless.agarmu.com";
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
        };
      };

      # file store for paperless

      services.rclone.mounts.paperless = {
        enable = true;
        accountIdFile = config.sops.secrets."rclone/paperless/account".path;
        appKeyFile = config.sops.secrets."rclone/paperless/key".path;
        bucketFile = config.sops.secrets."rclone/paperless/remote".path;
        mountPoint = "/mnt/paperless";
        group = "paperless";
      };

      # allow rclone service user to write with paperless group perms
      users.users.rclone.extraGroups = [ "paperless" ];

      # make paperless wait for mount (adjust unit name to your setup)
      systemd.services.paperless = {
        requires = [ "rclone-mount-paperless.service" ];
        after = [ "rclone-mount-paperless.service" ];
      };

      # setup dns for paperless service
      services.nginx.virtualHosts."paperless.agarmu.com" =
        let
          port = config.services.paperless.port;
        in
        {
          useACMEHost = "agarmu.com";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
    };
}
