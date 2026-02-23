_: {
  flake.modules.nixos.host-millet =
    { pkgs, config, ... }:
    let
      promPort = config.services.prometheus.port;
      lokiPort = config.services.loki.configuration.server.http_listen_port;
      grafanaPort = config.services.grafana.settings.server.http_port;
    in
    {
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 3000;
            domain = "grafana.agarmu.com";
            root_url = "https://grafana.agarmu.com";
          };
          security = {
            secret_key = "$__file{${config.sops.secrets."grafana-secret-key".path}}";
            admin_password = "$__file{${config.sops.secrets."grafana-admin-password".path}}";
          };
          analytics.reporting_enabled = false;
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString promPort}";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              url = "http://127.0.0.1:${toString lokiPort}";
            }
          ];
        };
      };

      services.nginx.virtualHosts."grafana.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString grafanaPort}";
          proxyWebsockets = true;
        };
      };
    };
}
