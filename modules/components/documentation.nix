_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      documentation.man.enable = true;
    };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.tealdeer = {
        enable = true;
        settings.updates.auto_update = true;
      };
    };
}
