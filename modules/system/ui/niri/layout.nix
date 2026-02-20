_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.layout = {
      focus-ring = {
        enable = false;
        width = 4;
        active.color = "#7fc8ff";
        inactive.color = "#505050";
      };

      border = {
        enable = false;
        width = 4;
        active.color = "#ffc87f";
        inactive.color = "#505050";
      };

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
    };
  };
}
