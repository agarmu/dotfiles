_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.noti = {
        enable = true;
      };
    };
}
