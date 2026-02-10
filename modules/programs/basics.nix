{ ... }:
{
  flake.modules.homeManager.base = {
    programs.man.enable = true;
    programs.info.enable = true;
  };
}
