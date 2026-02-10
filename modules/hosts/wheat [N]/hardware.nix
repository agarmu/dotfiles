{ inputs, ... }:
{
  flake-file.inputs.apple-silicon = {
    url = "github:nix-community/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.linux-desktop = {
    imports = [
      inputs.apple-silicon.nixosModules.default
    ]
    ++ [ ./_hardware-configuration.nix ];
    # nixpkgs.hostPlatform = "aarch64-linux";
  };
}
