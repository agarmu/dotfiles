{ lib, ... }:
{
  flake.modules.homeManager.nixosGui = {
    qt = {
      enable = true;
      platformTheme.name = lib.mkForce "kde";
      style.name = "breeze";
    };
  };
}
