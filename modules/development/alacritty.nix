_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        package = pkgs.alacritty-graphics;
        settings = {
          env.TERM = "alacritty";
          window = {
            decorations = "none";
            padding = {
              x = 10;
              y = 10;
            };
            dynamic_padding = true;
          };
        };
      };
      home.packages = with pkgs; [
        alacritty-graphics
        ncurses
      ];
    };
}
