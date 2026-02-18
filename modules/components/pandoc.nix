_: {
  flake.modules.homeManager.base = _: {
    programs.pandoc = {
      enable = true;
    };
  };
}
