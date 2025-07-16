{...}: {
  programs.alacritty = {
    enable = false;
    settings = {
      env.TERM = "alacritty";
      import = [
      ];
      window = {
        dimensions = {
          lines = 35;
          columns = 100;
        };
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_padding = false;
        decorations = "full";
        startup_mode = "windowed";
        opacity = 0.95;
      };
      scrolling = {
        history = 1000;
        multiplier = 5;
      };
      font = {
        normal = {
          family = "Fira Code Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "Fira Code Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Fira Code Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 12.0;
        builtin_box_drawing = true;
      };
      cursor = {
        style = "Block";
        blinking = "On";
      };
    };
  };
}
