_: {
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.difftastic = {
        enable = true;
      };
    };
}
