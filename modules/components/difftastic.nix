_: {
  flake.modules.homeManager.base = _: {
    programs.difftastic = {
      enable = true;
    };
  };
}
