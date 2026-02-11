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
          window.opacity = 0.85;
        };
      };
      home.packages = with pkgs; [
        alacritty
        ncurses
      ];
    };
}
