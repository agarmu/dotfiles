_:
let
  domain = "abshelf.agarmu.com";
  host = "millet";
  port = 8000;
in
{
  flake.modules.nixos.base.networking.dnscryptProxyCloaking."${domain}" = "${host}.hosts.agarmu.com";

  flake.modules.nixos."host-${host}" =
    { config, ... }:
    {
      services.audiobookshelf = {
        enable = true;
        host = "127.0.0.1";
        inherit port;
      };

      sops.templates."audiobookshelf-env" = {
        content = ''
          TOKEN_SECRET=${config.sops.placeholder."audiobookshelf-token-secret"}
        '';
        owner = "audiobookshelf";
      };

      systemd.services.audiobookshelf.serviceConfig.EnvironmentFile =
        config.sops.templates."audiobookshelf-env".path;

      services.caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          import tailnet_only
          tls internal
          reverse_proxy 127.0.0.1:${toString port}
        '';
      };
    };
}
