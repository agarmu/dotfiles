_: {
  flake.modules.nixos.base = _: {
    documentation.man.enable = true;
  };
  flake.modules.homeManager.base = _: {
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
