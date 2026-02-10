{ lib, ... }:
{
  flake.modules.nixos.base = {
    services.automatic-timezoned.enable = true;
    time.timeZone = lib.mkDefault "America/New_York";
  };
}
