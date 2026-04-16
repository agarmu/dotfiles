{
  flake.modules.homeManager.gui = {
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
