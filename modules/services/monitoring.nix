_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      promPort = config.services.prometheus.port;
      lokiPort = 3100;
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

      services.prometheus.listenAddress = "0.0.0.0"; # Accessible via Tailscale IP
      services.prometheus.webConfigFile = config.sops.secrets."prometheus-web-config".path;

      services.loki = {
        enable = true;
        configuration = {
          auth_enabled = false;
          server.http_listen_port = lokiPort;
          common = {
            path_prefix = config.services.loki.dataDir;
            replication_factor = 1;
            ring.kvstore.store = "inmemory";
            ring.instance_addr = "127.0.0.1";
          };
          schema_config.configs = [
            {
              from = "2024-01-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
          storage_config.filesystem.directory = "${config.services.loki.dataDir}/chunks";
        };
      };

      # Grafana and Prometheus are NOT exposed publicly - only accessible via Tailscale
      # Access at http://millet:3000 (Grafana) and http://millet:9090 (Prometheus) from any tailnet device

    };
}
