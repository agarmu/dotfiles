{ lib, ... }:
{
  flake.modules.homeManager.nixosGui = {
    programs.freetube.enable = true;
    catppuccin.freetube.enable = true;
  };
}
