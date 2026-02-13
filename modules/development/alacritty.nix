{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      catppuccin.alacritty.enable = true;
      programs.alacritty = {
        enable = true;
        package = pkgs.alacritty-graphics;
        settings = {
          env.TERM = "alacritty";
          window = {
            opacity = 0.75;
            decorations = "none";
            padding = {
              x = 10;
              y = 10;
            };
            dynamic_padding = true;
          };
          font =
            let
              fontName = "IoskeleyMono Nerd Font";
            in
            {
              normal = {
                family = fontName;
                style = "Regular";
              };
              bold = {
                family = fontName;
                style = "Bold";
              };
              italic = {
                family = fontName;
                style = "Italic";
              };
              size = 12.0;
            };
        };
      };
      home.packages = with pkgs; [
        alacritty-graphics
        ncurses
      ];
    };
}
