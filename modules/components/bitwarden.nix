{ ... }:
{
  flake.modules.homeManager.base =
    { ... }:
    {
      # better client for bitwarden
      programs.rbw.enable = true;
    };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.bitwarden-desktop ];
    };
}
