{
  flake.modules.homeManager.base = {
    programs.taskwarrior = {
      enable = true;
    };
  };
}
