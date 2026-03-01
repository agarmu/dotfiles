_: {
  flake.modules.homeManager.base = _: {
    home.sessionVariables = {
      LESS = "-FLRi -x2 --mouse";
      PAGER = "less";
    };
  };
  flake.modules.nixos.base = _: {
    environment.variables.LESSSECURE = "1";
  };
  flake.modules.darwin.base = _: {
    environment.variables.LESSSECURE = "1";
  };
}
