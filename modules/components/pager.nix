{
  flake.modules.homeManager.base = {
    home.sessionVariables = {
      LESS = "-FLRi -x2 --mouse";
      PAGER = "less";
    };
  };
  flake.modules.nixos.base = {
    environment.variables.LESSSECURE = "1";
  };
}
