{
  flake.modules.homeManager.gui =
    { pkgs, lib, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings.font.normal.family = "Nordwand Mono";
        settings.window = {
          opacity = 0.75;
          blur = true;
          padding = {
            x = 15;
            y = 15;
          };
        };
      };
      programs.ghostty = {
        enable = true;
        # ghostty-bin not avail on darwin for now..
        package =
          if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.ghostty then
            pkgs.ghostty
          else
            pkgs.ghostty-bin;
        settings = {
          font-family = "Nordwand Mono";
          font-size = 12;
          background-opacity = 0.75;
          window-padding-x = 15;
          window-padding-y = 15;
          window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
          cursor-style = "bar";
          cursor-style-blink = true;
          background-blur = true;
        };
      };
    };
  flake.modules.nixos.gui = {
    programs.nautilus-open-any-terminal = {
      terminal = "ghostty";
    };
  };
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];
    };
}
