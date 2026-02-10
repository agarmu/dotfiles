{ inputs, ... }:
{
  flake.modules.nixos.wheat = {
    nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "25.11";
  };
  flake.nixosConfigurations = inputs.self.lib.mkNixos "wheat";
}
