_: {
  flake.modules.homeManager.dev = {
    programs.zed-editor = {
      enable = true;
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
      };
    };
  };
}
