_: {
  flake.modules.homeManager.base = {
    programs.man = {
      enable = true;
      generateCaches = true;
    };
    programs.info.enable = true;
  };
}
