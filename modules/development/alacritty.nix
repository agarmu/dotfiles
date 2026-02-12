{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        package = pkgs.alacritty-graphics;
        theme = "catppuccin_mocha";
        settings = {
          env.TERM = "alacritty";
          window = {
            opacity = 0.75;
            decorations = "none";
          };
          font = {
            normal = {
              family = "Cascadia Code";
              style = "Regular";
            };
            bold = {
              family = "Cascadia Code";
              style = "Bold";
            };
            italic = {
              family = "Cascadia Code";
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
