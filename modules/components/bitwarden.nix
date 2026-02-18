_: {
  flake.modules.homeManager.base = _: {
    # better client for bitwarden
    programs.rbw.enable = true;
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.bitwarden-desktop ];
    };
}
