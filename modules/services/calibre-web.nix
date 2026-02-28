_:
{
  flake.modules.nixos.host-millet = {config, ...}:
    let calibrePort = config.services.calibre-web.listen.port;
    in
  {
    services.calibre-web = {
      enable = true;
      listen= {
        ip = "127.0.0.1";
        port = 23456;
      };
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
