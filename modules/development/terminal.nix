_: {
  flake.modules.homeManager.gui = _: {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 4;
            y = 4;
          };
          decorations = "None";
        };
      };
    };
  };
}
