{ inputs, lib, ... }:
{
  flake.modules.nixos.base = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

    # enable silent booting + systemd logs
    boot = {
      initrd = {
        systemd = {
          enable = true;
        };
        verbose = false;
      };
      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
      ];
    };
    boot.tmp.useTmpfs = true;
    systemd.targets.multi-user.enable = true;
  };

  # asahi needs apple silicon
  flake-file.inputs.apple-silicon = {
    url = "github:nix-community/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.asahi-firmware = {
    url = "git+ssh://git@github.com/agarmu/asahi-firmware.git";
    flake = false;
  };
  flake.modules.nixos.asahi = {
    imports = [
      inputs.apple-silicon.nixosModules.default
    ];
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
    hardware.asahi.peripheralFirmwareDirectory = "${inputs.asahi-firmware}";
  };
}
