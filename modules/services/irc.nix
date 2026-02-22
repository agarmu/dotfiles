_: {
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

      services.nginx.virtualHosts."irc.agarmu.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString ircPort}";
          proxyWebsockets = true;
        };
      };

      services.homepage-dashboard.services = [
        {
          "Services" = [
            {
              "The Lounge" = {
                href = "https://irc.agarmu.com";
                description = "IRC Client";
              };
            }
          ];
        }
      ];
    };
}
