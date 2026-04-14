_: {
  flake.modules.homeManager.base = _: {
    programs.sesh = {
      enable = true;
      enableAlias = true;
    };
  };
}
