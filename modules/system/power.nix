{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ acpi ];
    };

  flake.modules.nixos.mobile = _: {
    services.tlp.enable = true;
  };
  flake.modules.homeManager.mobile =
    { pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.isDarwin [ pkgs.coconutbattery ];
    };
}
