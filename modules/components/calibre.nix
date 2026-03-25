_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.calibre = {
        enable = true;
        package = pkgs.calibre-no-speech;
      };
    };
}
