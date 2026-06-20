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
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # download directory
          "browser.download.useDownloadDir" = false;

          # Disable fx accounts
          "identity.fxaccounts.enabled" = false;
          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # Harden
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;

          # don't overcorrect - uBO does what i need
          "browser.contentblocking.category" = "standard";
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
