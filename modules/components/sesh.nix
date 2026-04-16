{
  flake.modules.homeManager.base = {
    programs.sesh = {
      enable = true;
      enableAlias = true;
    };
  };
}
