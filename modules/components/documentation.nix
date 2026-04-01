{ lib, ... }:
{
  flake.modules.nixos.base.documentation = {
    man = {
      enable = true;
      cache.enable = lib.mkForce false;
    };
    nixos.enable = true;
    doc.enable = false;
    info.enable = false;
  };
  flake.modules.homeManager.base = _: {
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
