{ lib, ... }:
{
  flake.modules.homeManager.nixosGui = {
    programs.imv.enable = true;
    catppuccin.imv.enable = true;
  };
}
