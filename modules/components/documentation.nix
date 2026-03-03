_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      documentation = {
        enable = true;
        man = {
          enable = true;
          generateCaches = true;
        };
        info.enable = true;
        doc.enable = true;
        dev.enable = true;
      };
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
