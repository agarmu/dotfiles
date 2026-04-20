_: {
  flake.modules.homeManager.nixosGui = {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "overlay";
        cssPriority = "user";

        timeout = 8;
        timeout-low = 4;
        timeout-critical = 0;

        notification-window-width = 400;
        control-center-width = 450;

        fit-to-screen = true;
        relative-timestamps = true;
        notification-icon-size = 48;
        notification-body-image-height = 100;
        notification-body-image-width = 200;

        widgets = [
          "title"
          "dnd"
          "mpris"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd = {
            text = "Do Not Disturb";
          };
          mpris = {
            image-size = 80;
            image-radius = 8;
          };
        };

        notification-visibility = { };
      };
    };
    stylix.targets.swaync.enable = true;
  };
}
