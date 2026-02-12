_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.difftastic = {
        enable = true;
      };
      catppuccin.delta.enable = true;
    };
}
