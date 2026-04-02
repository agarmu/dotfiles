_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.layout = {
      focus-ring.enable = false;
      border.enable = false;
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 0.5;
      };
      gaps = 16;
      center-focused-column = "never";
      always-center-single-column = true;
    };
  };
}
