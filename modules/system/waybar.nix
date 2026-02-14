{ lib, ... }:
{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
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
