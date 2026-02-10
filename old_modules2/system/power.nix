{ pkgs, ... }:
{
  flake.modules.nixos.base = {
    environment.systemPackages = [ pkgs.acpi ];
  };
  flake.modules.nixos.mobile = {
    services.tlp.enable = true;
  };
}
