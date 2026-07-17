{
  flake.modules.homeManager.dev = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
      };
    };
  };
}
