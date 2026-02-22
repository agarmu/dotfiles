_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      promPort = config.services.prometheus.port;
      nodePort = config.services.prometheus.exporters.node.port;
      nginxPort = config.services.prometheus.exporters.nginx.port;
    in
    {
      services.prometheus = {
        enable = true;
        port = 9090;

        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" ];
            port = 9100;
          };
          nginx = {
            enable = true;
            port = 9113;
          };
        };

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString nodePort}" ];
              }
            ];
          }
          {
            job_name = "nginx";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString nginxPort}" ];
              }
            ];
          }
        ];
      };

      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "0.0.0.0"; # Listen on all interfaces (accessible via Tailscale IP)
            http_port = 3000;
          };
          security = {
            # TODO: Move to sops-nix for proper secret management
            secret_key = "1234";
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
          ];
        };
      };

      services.prometheus.listenAddress = "0.0.0.0"; # Accessible via Tailscale IP

      # Grafana and Prometheus are NOT exposed publicly - only accessible via Tailscale
      # Access at http://millet:3000 (Grafana) and http://millet:9090 (Prometheus) from any tailnet device

      services.homepage-dashboard.services = [
        {
          "Monitoring (Tailscale only)" = [
            {
              "Grafana" = {
                href = "http://millet:3000";
                description = "Metrics & Dashboards";
              };
            }
            {
              "Prometheus" = {
                href = "http://millet:9090";
                description = "Raw Metrics";
              };
            }
          ];
        }
      ];
    };
}
