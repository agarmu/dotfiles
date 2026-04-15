_:
let
  domain = "dash.internal";
  host = "millet";
  port = 8080;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";

  flake.modules.nixos."host-${host}" = {
    services.glance = {
      enable = true;
      settings = {
        server = {
          host = "127.0.0.1";
          inherit port;
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
                        title = "Purdue";
                        links = [
                          {
                            title = "myPurdue";
                            url = "https://mypurdue.purdue.edu";
                          }
                          {
                            title = "Gradescope";
                            url = "https://gradescope.com";
                          }
                          {
                            title = "Brightspace";
                            url = "https://purdue.brightspace.com";
                          }
                        ];
                      }
                      {
                        title = "General";
                        links = [
                          {
                            title = "Google Drive";
                            url = "https://drive.google.com";
                          }
                          {
                            title = "GitHub";
                            url = "https://github.com";
                          }
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

    services.caddy.virtualHosts."${domain}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
