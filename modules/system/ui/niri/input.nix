_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.input = {
      keyboard.xkb.layout = "us";

      touchpad = {
        tap = true;
        dwt = true;
        natural-scroll = true;
        accel-speed = 0.2;
      };

      mouse = {
        accel-profile = "flat";
      };

      tablet.map-to-output = "eDP-1";
      touch.map-to-output = "eDP-1";
    };
  };
}
