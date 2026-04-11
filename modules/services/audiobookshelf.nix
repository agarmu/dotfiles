_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      services.audiobookshelf = {
        enable = true;
        host = "127.0.0.1";
        port = 8000;
      };

      sops.templates."audiobookshelf-env" = {
        content = ''
          TOKEN_SECRET=${config.sops.placeholder."audiobookshelf-token-secret"}
        '';
        owner = "audiobookshelf";
      };

      systemd.services.audiobookshelf.serviceConfig.EnvironmentFile =
        config.sops.templates."audiobookshelf-env".path;

      services.nginx.virtualHosts."audiobookshelf.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
      };
    };
}
