{
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.mangohud = {
        enable = true;
        package = pkgs.mangohud.override {
          x11Support = false;
          gamescopeSupport = false;
        };
      };
    };
}
