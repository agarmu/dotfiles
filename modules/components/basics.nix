_: {
  flake.modules.homeManager.base = _: {
    programs.man = {
      enable = true;
      generateCaches = true;
    };
    programs.info.enable = true;
  };
}
