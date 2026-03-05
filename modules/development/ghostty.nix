_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          window-decoration = false;
        };
      };
    };
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];
    };
}
