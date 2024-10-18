{
  pkgs,
  lib,
  ...
}: {
  # Enable flakes globally
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Set trusted users
  nix.settings.trusted-users = ["root" "mukul" "admin"];
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://cachix.org/api/v1/cache/nix-community"
  ];

  nix.settings.trusted-substituters = [
    "https://cache.nixos.org"
  ];

  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  nix.gc = {
    automatic = true;
    options = lib.mkDefault "--delete-older-than 1w";
  };
  # Optimize Nix Store
  # disabled due to: https://github.com/NixOS/nix/issues/7273
  # TODO: FIX This
  nix.settings.auto-optimise-store = false;
  # Optimize Nix build cores/jobs
  nix.settings.cores = 0;
  nix.settings.max-jobs = "auto";
}
