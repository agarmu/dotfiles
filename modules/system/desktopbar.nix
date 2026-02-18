{ ... }:
{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
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
      programs.waybar = {
        enable = false;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 32;
            output = [
              "eDP-1"
            ];
            modules-left = [
              "custom/separator"
              "battery"
            ];
            #modules-center = [ "sway/window" "custom/hello-from-waybar" ];
            modules-right = [
              "mpd"
              "custom/mymodule#with-css-id"
              "temperature"
            ];

            "custom/separator" = {
              "format" = "|";
              "interval" = "once";
              "tooltip" = false;
            };
          };
        };
      };
    };
}
