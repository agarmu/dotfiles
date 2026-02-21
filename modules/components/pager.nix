_: {
  flake.modules.homeManager.base = _: {
    home.sessionVariables = {
      LESS = "-LSRci -x4 --mouse";
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
