{ lib, ... }:
{
  flake.modules.homeManager.base = _: {
    programs.difftastic = {
      enable = lib.mkDefault true;
      git = {
        enable = true;
        diffToolMode = true;
      };
      jujutsu.enable = true;
    };
  };
}
