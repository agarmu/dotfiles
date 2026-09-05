{
  flake.modules.homeManager.gui =
    { lib, ... }:
    let
      purelymailAddresses = [
        "acme@agarmu.com"
        "irc@agarmu.com"
        "matrixbot@agarmu.com"
        "agarmu@purelymail.com"
        "basicservices@purelymail.com"
        "boinc@agarmu.com"
        "curius@agarmu.com"
        "evernote@purelymail.com"
        "gscholaralerts@agarmu.com"
        "lobsters@agarmu.com"
        "millet@agarmu.com"
        "mukul@agarmu.com"
        "newsletter@agarmu.com"
        "testing123@agarmu.com"
        "vcs@agarmu.com"
        "xfit@purelymail.com"
      ];
    in
    {
      programs.thunderbird = {
        enable = true;
        profiles = {
          default.isDefault = true;
          purelymail = { };
        };
      };

      accounts.email.accounts = lib.genAttrs purelymailAddresses (address: {
        inherit address;
        realName = "Mukul Agarwal";
        userName = address;
        primary = address == "mukul@agarmu.com";
        imap = {
          host = "imap.purelymail.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.purelymail.com";
          port = 465;
          tls.enable = true;
        };
        # Thunderbird prompts for and stores each mailbox's password locally.
        thunderbird = {
          enable = true;
          profiles = [ "purelymail" ];
        };
      });
    };
  flake.modules.homeManager.linuxGui = {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
    };
  };
}
