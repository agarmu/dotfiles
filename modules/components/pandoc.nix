_: {
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.pandoc = {
        enable = true;
      };
    };
}
