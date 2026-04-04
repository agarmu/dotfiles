_: {
  flake.modules.home.nixosGui =
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
