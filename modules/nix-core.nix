{
  pkgs,
  lib,
  ...
}: {
  # enable flakes globally
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  nix.gc = {
    automatic = true;
    interval = {
      Hour = 24;
      Minute = 0;
    };
    options = lib.mkDefault "--delete-older-than 1w";
  };
  # Optimize Nix Store
  nix.settings.auto-optimise-store = true;
}
