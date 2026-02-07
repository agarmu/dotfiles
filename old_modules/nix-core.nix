{
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.lix;
    gc = {
      automatic = true;
      options = lib.mkDefault "--delete-older-than 1w";
    };
    settings = {
      # Enable flakes globally
      experimental-features = ["nix-command" "flakes"];
      # Set trusted users
      substituters = [
        "https://cache.nixos.org"
        "https://cachix.org/api/v1/cache/nix-community"
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # disabled due to: https://github.com/NixOS/nix/issues/7273
      # TODO: FIX This
      # TODO: Should be fixed now... musl issue? check it out at some point
      auto-optimise-store = false;

      # optimize builds
      cores = 0;
      max-jobs = "auto";
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Auto upgrade nix package and the daemon service.

  programs.nix-index.enable = true;
}
