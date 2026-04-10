_: {
  flake.modules.homeManager.gui = _: {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "message/rfc822" = [ "thunderbird.desktop" ];
    };
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };
  };
}
