_: {
  flake.modules.homeManager.gui = _: {
    programs.firefox.policies = {
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
}
