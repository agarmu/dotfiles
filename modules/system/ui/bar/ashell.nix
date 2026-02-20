_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.ashell = {
      enable = true;
      systemd.enable = true;
      settings = {
        modules = {
          center = [
          ];
          left = [
            "Workspaces"
            "WindowTitle"
          ];
          right = [
            "SystemInfo"
            [
              "Clock"
              "Privacy"
              "Settings"
            ]
          ];
        };
        visibility_mode = {
          visibility_mode = "MonitorSpecific";
        };
      };
    };
  };
}
