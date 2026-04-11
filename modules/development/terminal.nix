_: {
  flake.modules.homeManager.gui = _: {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding =
            let
              u = 15;
            in
            {
              x = u;
              y = u;
            };
          dynamic_padding = true;
          blur = true;
          decorations = "None";
        };
        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };
          unfocused_hollow = false;

        };
      };
    };
  };
}
