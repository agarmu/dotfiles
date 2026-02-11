{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ acpi ];
      services.tlp.enable = true;
    };

  flake.modules.nixos.mobile =
  { pkgs, ... }:
  {
    services.tlp.enable = true;
  };
  flake.modules.homeManager.mobile = {pkgs, ...}:
  {
    home.packages = [pkgs.coconutbattery];
  };
}
