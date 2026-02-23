_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      nodePort = config.services.prometheus.exporters.node.port;
      nginxPort = config.services.prometheus.exporters.nginx.port;
    in
    {
      services.prometheus = {
        enable = true;
        port = 9090;
        listenAddress = "127.0.0.1";

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
    };
}
