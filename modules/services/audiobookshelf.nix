_: {
  flake.modules.nixos.base.networking.dnscryptProxyCloaking."audiobookshelf.agarmu" = "millet.agarmu";

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

      services.caddy.virtualHosts."audiobookshelf.agarmu" = {
        extraConfig = ''
          import tailnet_only
          tls internal
          reverse_proxy 127.0.0.1:8000
        '';
      };
    };
}
