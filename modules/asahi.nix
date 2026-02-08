{ lib, config, ... }:
{
  config.flake = {
    nixosConfigurations."mbp-asahi" = lib.nixosSystem {
      modules = [ ../configuration.nix ];
    };
  };
}
