_: {
  flake.modules.nixos.base.networking.dnscryptProxyCloaking."irc.agarmu" = "millet.agarmu";

  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      ircPort = config.services.thelounge.port;
    in
    {
      services.thelounge = {
        enable = true;
        port = 9000;
        extraConfig = {
          reverseProxy = true;
          prefetch = true;
          fileUpload.enable = true;
        };
      };

      services.caddy.virtualHosts."irc.agarmu" = {
        extraConfig = ''
          import tailnet_only
          tls internal
          reverse_proxy 127.0.0.1:${toString ircPort}
        '';
      };

    };
}
