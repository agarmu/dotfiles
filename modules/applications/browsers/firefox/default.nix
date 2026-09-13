{
  flake.modules.homeManager.gui = { pkgs, ... }: {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles.default = {
        id = 0;
        settings = {

          # first run options
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # download directory
          "browser.download.useDownloadDir" = false;

          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # Harden
          "privacy.trackingprotection.enabled" = true;

          # don't overcorrect - uBO does what i need
          "browser.contentblocking.category" = "standard";
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DontCheckDefaultBrowser = true;
        HttpsOnlyMode = "force_enabled";

        FirefoxHome = {
          SponsoredTopSites = false;
          SponsoredStories = false;
          Stories = false;
          Highlights = false;
        };

        # Disable saving logins, payment details, addresses, and form/search entries.
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        AutofillCreditCardEnabled = false;
        AutofillAddressEnabled = false;
        DisableFormHistory = true;
        ExtensionUpdate = false;
        Preferences = {
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.generation.enabled" = false;
        };
      };
    };
  };
}
