_: {
  flake.modules.homeManager.base = _: {
    programs.taskwarrior = {
      enable = true;
    };
  };
}
