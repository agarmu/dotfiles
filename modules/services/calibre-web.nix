_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      calibrePort = config.services.calibre-web.listen.port;
    in
    {
      services.calibre-web = {
        enable = true;
        listen = {
          ip = "127.0.0.1";
          port = 23456;
        };
        options = {
          enableBookConversion = true;
          enableBookUploading = true;
          enableKepubify = true;
          calibreLibrary = "/mnt/calibre";
        };
      };
      sops.secrets."rclone/calibre/remote" = {
        owner = "rclone";
        group = "rclone";
      };
      sops.secrets."rclone/calibre/account" = {
        owner = "rclone";
        group = "rclone";
      };
      sops.secrets."rclone/calibre/key" = {
        owner = "rclone";
        group = "rclone";
      };
      services.rclone.mounts.calibre-web = {
        enable = true;
        accountIdFile = config.sops.secrets."rclone/calibre/account".path;
        appKeyFile = config.sops.secrets."rclone/calibre/key".path;
        bucketFile = config.sops.secrets."rclone/calibre/remote".path;
        mountPoint = "/mnt/calibre";
        group = "calibre-web";
        dependents = [ "calibre-web.service" ];
      };
      services.nginx.virtualHosts."calibre.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString calibrePort}";
          proxyWebsockets = true;
        };
      };
    };
}
