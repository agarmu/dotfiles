{
  inputs,
  lib,
  config,
  ...
}:
{
  flake = {
    nixosConfigurations."mbp-asahi" = lib.nixosSystem {
      modules = [
        ../configuration.nix
        inputs.apple-silicon.nixosModules.default
      ];
    };
  };
}
