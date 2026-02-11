{ lib, ... }:
{
  flake.modules.nixos.base = {
    time.timeZone = lib.mkDefault "America/New_York";
    services.automatic-timezoned.enable = true;

  };
}
