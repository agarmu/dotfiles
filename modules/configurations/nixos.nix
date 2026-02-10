{ lib, config, ... }:
{
  flake.nixosConfigurations."wheat" = lib.nixosSystem {
    modules = [ config.flake.modules.nixos.hosts.wheat ];
    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
