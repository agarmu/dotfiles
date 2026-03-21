_: {
  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "floorp.desktop" ];
        "x-scheme-handler/http" = [ "floorp.desktop" ];
        "x-scheme-handler/https" = [ "floorp.desktop" ];
        "x-scheme-handler/about" = [ "floorp.desktop" ];
        "x-scheme-handler/unknown" = [ "floorp.desktop" ];
      };
      stylix.targets.floorp = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
        colors.override = (
          config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml"
        );
      };
      programs.floorp = {
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
