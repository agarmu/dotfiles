_: {
  flake.modules.nixos.host-millet =
    { config, ... }:
    let
      glancePort = config.services.glance.settings.server.port;
    in
    {
      services.glance = {
        enable = true;
        settings = {
          server = {
            host = "127.0.0.1";
            port = 8080;
          };
          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
{
                      type = "bookmarks";
                      groups = [
                        {
                          title = "Services";
                          links = [
                            { title = "IRC"; url = "https://irc.agarmu.com"; }
                            { title = "Grafana"; url = "http://millet:3000"; }
                            { title = "Prometheus"; url = "http://millet:9090"; }
                          ];
                        }
                        {
                          title = "Purdue";
                          links = [
                            { title = "myPurdue"; url = "https://mypurdue.purdue.edu"; }
                            { title = "Gradescope"; url = "https://gradescope.com"; }
                            { title = "Brightspace"; url = "https://purdue.brightspace.com"; }
                          ];
                        }
                        {
                          title = "General";
                          links = [
                            { title = "Google Drive"; url = "https://drive.google.com"; }
                            { title = "GitHub"; url = "https://github.com"; }
                          ];
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "lobsters";
                          limit = 15;
                        }
                        {
                          type = "hacker-news";
                          limit = 15;
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      services.nginx.virtualHosts."dash.agarmu.com" = {
        useACMEHost = "agarmu.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString glancePort}";
          proxyWebsockets = true;
        };
      };
    };
}
