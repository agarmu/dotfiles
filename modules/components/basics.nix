_: {
  flake.modules.homeManager.base = _: {
    programs.man = {
      enable = true;
      generateCaches = true;
    };
    programs.info.enable = true;
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
