{ mainUser, ... }:
{
  flake.modules.nixos.base = {
    services.seatd.enable = true;
    services.libinput.enable = true;
  };
}
