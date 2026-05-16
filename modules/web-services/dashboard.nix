{
  flake.modules.nixos.base.web-services.dash = {
    host = "millet";
    port = 8080;
  };

  flake.modules.nixos.host-millet = {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 8080;
      allowedHosts = "dash.internal";

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
  };
}
