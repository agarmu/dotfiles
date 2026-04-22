_:
let
  domain = "dash.internal";
  host = "millet";
  port = 8080;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";

  flake.modules.nixos."host-${host}" = {
    services.homepage-dashboard = {
      enable = true;
      listenPort = port;
      allowedHosts = domain;

      settings = {
        title = "Dashboard";
        headerStyle = "clean";
      };

      bookmarks = [
        {
          Purdue = [
            {
              myPurdue = [
                {
                  abbr = "mP";
                  href = "https://mypurdue.purdue.edu";
                }
              ];
            }
            {
              "One Purdue" = [
                {
                  abbr = "1P";
                  href = "https://one.purdue.edu";
                }
              ];
            }
            {
              Gradescope = [
                {
                  abbr = "GS";
                  href = "https://gradescope.com";
                }
              ];
            }
            {
              Brightspace = [
                {
                  abbr = "BS";
                  href = "https://purdue.brightspace.com";
                }
              ];
            }
          ];
        }
        {
          General = [
            {
              "Google Drive" = [
                {
                  abbr = "GD";
                  href = "https://drive.google.com";
                }
              ];
            }
            {
              GitHub = [
                {
                  abbr = "GH";
                  href = "https://github.com";
                }
              ];
            }
          ];
        }
      ];

      services = [
        {
          Services = [
            {
              "Change Detection" = {
                description = "Website change monitoring";
                href = "https://change.internal";
              };
            }
            {
              Audiobookshelf = {
                description = "Audiobook & podcast server";
                href = "https://abook.internal";
              };
            }
            {
              Wakapi = {
                description = "Coding activity tracker";
                href = "https://wakapi.internal";
              };
            }
            {
              Grocy = {
                description = "Grocery & household management";
                href = "https://grocy.internal";
              };
            }
            {
              "The Lounge" = {
                description = "IRC web client";
                href = "https://irc.internal";
              };
            }
            {
              Karakeep = {
                description = "Bookmark manager";
                href = "https://karakeep.internal";
              };
            }
          ];
        }
      ];

      widgets = [
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
    };

    services.caddy.virtualHosts."${domain}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
