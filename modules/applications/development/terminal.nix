{
  flake.modules.homeManager.gui =
    { pkgs, lib, ... }:
    {
      programs.ghostty = {
        enable = true;
        # ghostty-bin not avail on darwin for now..
        package =
          if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.ghostty then
            pkgs.ghostty
          else
            pkgs.ghostty-bin;
        settings = {
          window-padding-x = 15;
          window-padding-y = 15;
          window-decoration = (pkgs.stdenv.hostPlatform.isDarwin);
          cursor-style = "bar";
          cursor-style-blink = true;
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
