{ lib, ... }:
{
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      dashboardPort = config.services.homepage-dashboard.listenPort;
    in
    {
      services.homepage-dashboard = {
        enable = true;
        listenPort = 8082;

        settings = {
          title = "Millet Services";
          headerStyle = "boxed";
        };

        services = lib.mkMerge [
          # Each service module contributes its own entry via services.homepage-dashboard.services
        ];

        widgets = [
          {
            resources = {
              cpu = true;
              memory = true;
              disk = "/";
            };
          }
        ];
      };

      services.nginx.virtualHosts."dash.agarmu.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString dashboardPort}";
          proxyWebsockets = true;
        };
      };
    };
}
