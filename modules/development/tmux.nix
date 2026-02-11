{ pkgs, ... }:
{
  home.modules.homeManager.dev = {
    programs.tmux.enable = true;
  };
}
