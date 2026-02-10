{
  inputs,
  ...
}:
{
  # default settings needed for all nixosConfigurations

  flake.modules.nixos.system-minimal =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        (final: _prev: {
          unstable = import inputs.nixpkgs {
            inherit (final) config;
            system = pkgs.stdenv.hostPlatform.system;
          };
        })
      ];
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "25.05";

      nix.settings = {
        substituters = [
          # high priority since it's almost always used
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
          # "allow-import-from-derivation"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';

    };
}
