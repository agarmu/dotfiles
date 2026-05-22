{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      zoomSiteId = "01KS6HCS6KG6DQ7KRGHNH9J8DP";
      zoom-icon = pkgs.fetchurl {
        url = "https://app.zoom.us/apple-touch-icon.png";
        hash = "sha256-nr6BFzsHIt8KbKtLJ7+0eE1y7hHfqKsz2Py+04FjE2Y=";
      };
      # Translates zoommtg:// and zoomus:// URIs to https://app.zoom.us/wc/… and
      # opens them in the Zoom PWA via firefoxpwa.
      #
      # zoommtg://zoom.us/join?confno=12345&pwd=XXXX
      #   -> https://app.zoom.us/wc/12345/join?pwd=XXXX
      zoom-uri-handler = pkgs.writeShellApplication {
        name = "zoom-uri-handler";
        runtimeInputs = [ pkgs.firefoxpwa ];
        text = ''
          uri="$1"

          # Strip the scheme (zoommtg:// or zoomus://) and the host (zoom.us)
          # leaving just the path+query, e.g. /join?confno=12345&pwd=XXXX
          path_query="''${uri#*://zoom.us}"

          # Extract the action (join / start) and query string
          action="''${path_query%%\?*}"
          action="''${action#/}"
          query="''${path_query#*\?}"

          # Pull confno and pwd out of the query string
          confno="$(echo "$query" | grep -oP '(?<=confno=)[^&]+')"
          pwd="$(echo "$query" | grep -oP '(?<=pwd=)[^&]+' || true)"

          if [ -n "$pwd" ]; then
            url="https://app.zoom.us/wc/''${confno}/''${action}?pwd=''${pwd}"
          else
            url="https://app.zoom.us/wc/''${confno}/''${action}"
          fi

          exec firefoxpwa site launch ${zoomSiteId} --url "$url"
        '';
      };
    in
    {
      programs.firefoxpwa = {
        enable = true;

        profiles = {
          "01KS6HCS6KN5XDPCMC4NPR9ZSV" = {
            name = "Default";

            sites = {
              ${zoomSiteId} = {
                name = "Zoom";
                url = "https://app.zoom.us/wc/";
                manifestUrl = "https://app.zoom.us/wc/manifest.json";

                desktopEntry = {
                  categories = [
                    "Network"
                    "VideoConference"
                  ];
                  icon = "${zoom-icon}";
                };
              };
            };
          };
        };
      };

      xdg.desktopEntries.zoom-uri-handler = {
        name = "Zoom URI Handler";
        exec = "${zoom-uri-handler}/bin/zoom-uri-handler %u";
        noDisplay = true;
        mimeType = [
          "x-scheme-handler/zoommtg"
          "x-scheme-handler/zoomus"
          "x-scheme-handler/zoom"
        ];
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/zoommtg" = [ "zoom-uri-handler.desktop" ];
        "x-scheme-handler/zoomus" = [ "zoom-uri-handler.desktop" ];
        "x-scheme-handler/zoom" = [ "zoom-uri-handler.desktop" ];
      };
    };
}
