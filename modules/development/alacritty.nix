{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      package = pkgs.alacritty-graphics;
    in
    {
      programs.alacritty = {
        inherit package;
        enable = true;
        theme = "catppuccin_mocha";
        settings = {
          env.TERM = "alacritty";
          window.opacity = 0.6;
        };
      };
      home.packages = [ package ];
    };
}
