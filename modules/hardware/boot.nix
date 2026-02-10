# Boot loader configuration
{
  inputs,
  lib,
  pkgs,
  rootPath,
  ...
}:
{
  flake.modules.nixos = {
    # efi support
    base = {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    };
    # asahi modifications
    asahi = {
      imports = [ inputs.apple-silicon.nixosModules.default ];
      # asahi has weird efi system
      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
      hardware.asahi.peripheralFirmwareDirectory = rootPath + "/firmware";
    };
  };
}
