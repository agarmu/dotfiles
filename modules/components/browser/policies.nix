_: {
  flake.modules.homeManager.gui = _: {
    programs.firefox.policies = {
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
