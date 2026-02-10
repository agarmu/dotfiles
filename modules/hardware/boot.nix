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

      # TODO: figure out how to fix
      # ref: https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration
      hardware.asahi.peripheralFirmwareDirectory = rootPath + "/firmware";
    };
  };
}
