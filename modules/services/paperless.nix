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
