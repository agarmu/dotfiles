{ lib, ... }:
{
  flake.modules.nixos.office = {
    services.printing.enable = true;
  };
}
