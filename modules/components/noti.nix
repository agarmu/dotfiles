_: {
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.noti = {
        enable = true;
      };
    };
}
