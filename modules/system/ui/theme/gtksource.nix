# disable stylix for gtksourceview
{ lib, ... }:
let
  cfg = {
    stylix.targets.gtksourceview.enable = lib.mkForce false;
  };
in
{
  flake.modules = {
    nixos.base = cfg;
    homeManager.base = cfg;
  };
}
