{ lib, ... }:
{
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.htop.enable = true;
      programs.btop.enable = true;
    };
}
