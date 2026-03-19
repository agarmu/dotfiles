{ inputs, ... }:
{

  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
        "x-scheme-handler/about" = [ "librewolf.desktop" ];
        "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
      };
      stylix.targets.librewolf = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
        colors.override = (
          config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml"
        );
      };
      programs.librewolf = {
        enable = true;
        profiles.default = {
          id = 0;
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
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
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;

          # optional hard-disable bits
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
