_: {
  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
      stylix.targets.firefox = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
        colors.override = (
          config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml"
        );
      };
      programs.firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
              darkreader
              libredirect
              consent-o-matic
              web-archives
              zotero-connector
            ];
          };
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.translations" = "blocked";
          };
        };
        policies = {
          NewTabPage = {
            URL = "https://dash.agarmu.com";
            Enabled = true;
          };
          Homepage = {
            URL = "https://dash.agarmu.com";
            StartPage = "homepage";
          };
          FirefoxHome = {
            SponsoredTopSites = false;
            SponsoredPocket = false;
          };
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
          CredentialsEnableService = false;
          Preferences = {
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;
            "signon.generation.enabled" = false;
          };
        };
      };
    };
}
