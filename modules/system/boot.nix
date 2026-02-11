{ inputs, lib, ... }:
{
  flake.modules.nixos.base = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  };

  # asahi needs apple silicon
  flake-file.inputs.apple-silicon = {
    url = "github:nix-community/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.asahi = {
    imports = [
      inputs.apple-silicon.nixosModules.default
    ];
    boot.loader.systemd-boot.enable = lib.mkForce true;
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  };
}
