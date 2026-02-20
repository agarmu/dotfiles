_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.outputs."eDP-1" = {
      scale = 2.0;

      transform = {
        rotation = 0;
        flipped = false;
      };

      mode = {
        width = 1920;
        height = 1080;
        refresh = 120.030;
      };

      position = {
        x = 1280;
        y = 0;
      };
    };
  };
}
