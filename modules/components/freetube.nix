{ ... }:
{
  flake.modules.homeManager.nixosGui = {
    programs.freetube.enable = true;
  };
}
