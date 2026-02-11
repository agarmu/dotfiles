_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.pandoc = {
        enable = true;
      };
    };
}
