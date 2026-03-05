_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
        ];
      };
    };
  };
}
