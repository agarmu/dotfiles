{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      # better client for bitwarden
      programs.rbw.enable = true;
      home.packages = [ pkgs.bitwarden-cli ];
    };
}
