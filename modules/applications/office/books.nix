{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      programs.foliate = {
        enable = true;
      };
      programs.calibre = {
        enable = true;
        package = pkgs.calibre-no-speech;
      };
    };
}
