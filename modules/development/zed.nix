{
  flake.modules.homeManager.dev = {
    programs.zed-editor = {
      enable = false;
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
      };
    };
  };
}
