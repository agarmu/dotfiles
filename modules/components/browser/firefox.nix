{ lib, ... }:
{
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
          search = {
            force = true;
            default = "google";
            privateDefault = "ddg";
            order = [
              "ddg"
              "wikipedia"
            ];
            engines = {
              nwiki = {
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              };
              bing.metaData.hidden = true;
            };
          };
          /*
             some settings adapted from
             https://github.com/Misterio77/nix-config/blob/main/home/gabriel/features/desktop/common/firefox.nix
          */
          settings = {
            # to configure w stylix
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # first run options
            "browser.disableResetPrompt" = true;
            "browser.download.panel.shown" = true;
            "browser.feeds.showFirstRunUI" = false;
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.rights.3.shown" = true;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.defaultBrowserCheckCount" = 1;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.uitour.enabled" = false;
            "startup.homepage_override_url" = "";
            "trailhead.firstrun.didSeeAboutWelcome" = true;
            "browser.bookmarks.restore_default_bookmarks" = false;
            "browser.bookmarks.addedImportButton" = true;

            # i hate browser ai
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ai.control.translations" = "blocked";

            # download directory
            "browser.download.useDownloadDir" = false;

            # make homepage less bad
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
            "browser.newtabpage.blocked" = lib.genAttrs [
              # Youtube
              "26UbzFJ7qT9/4DhodHKA1Q=="
              # Facebook
              "4gPpjkxgZzXPVtuEoAL9Ig=="
              # Wikipedia
              "eV8/WsSLxHadrTL1gAxhug=="
              # Reddit
              "gLv0ja2RYVgxKdp0I5qwvA=="
              # Amazon
              "K00ILysCaEq8+bEqV/3nuw=="
              # Twitter
              "T9nJot5PurhJSy8n038xGA=="
            ] (_: 1);

            # Disable some telemetry
            "app.shield.optoutstudies.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.sessions.current.clean" = true;
            "devtools.onboarding.telemetry.logged" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.updatePing.enabled" = false;

            # Disable fx accounts
            "identity.fxaccounts.enabled" = false;
            # Disable "save password" prompt
            "signon.rememberSignons" = false;
            # Harden
            "privacy.trackingprotection.enabled" = true;
            "dom.security.https_only_mode" = true;
          };
        };
        policies = {
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
