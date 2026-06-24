{ lib, ... }: {
  flake.modules.homeManager.gui = { pkgs, ... }: {
    home.packages = (
      lib.optionals (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.zoom-us) [ pkgs.zoom-us ]
    );
  };
}
