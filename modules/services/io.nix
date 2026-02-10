{ lib, ... }:
{
  flake.modules.nixos.base = {
    services.libinput.enable = true;
    services.seatd.enable = true;
  };
}
