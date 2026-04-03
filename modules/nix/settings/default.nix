{ lib, ... }:
let
  nix = {
    enable = lib.mkDefault true;
    settings =
      let
        subs = [
          "https://cache.nixos.org"
          "https://cachix.org/api/v1/cache/nix-community"
          "https://nixos-apple-silicon.cachix.org"
          "https://noctalia.cachix.org"
        ];
      in
      {
        use-xdg-base-directories = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operator"
        ];
        substituters = subs;
        trusted-substituters = subs;
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
        trusted-users = [
          "root"
          "@wheel"
          "@admin" # for macOS
        ];
        /*
          should be fixed by the following issue... check
          for regressions.
          [https://github.com/NixOS/nix/issues/7273]
        */
        auto-optimise-store = true;

        # optimize builds
        cores = 0;
        max-jobs = "auto";
      };
    distributedBuilds = true;
  };
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nix = {
        package = pkgs.lix;
        optimise.automatic = true;
      }
      // nix;

      programs.nh.clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 7d";
      };
    };

  # Mobile systems: clean twice-weekly (Wed/Sun)
  flake.modules.nixos.mobile = {
    programs.nh.clean.dates = "Wed,Sun 03:00:00";
  };

  # Server systems: clean daily
  flake.modules.nixos.server = {
    programs.nh.clean.dates = "*-*-* 03:00:00";

    nix.optimise.dates = [ "*-*-* 03:30:00" ];

    systemd.timers.nh-clean.timerConfig = {
      Persistent = lib.mkForce false;
      RandomizedDelaySec = lib.mkForce 0;
    };
    systemd.timers.nix-optimise.timerConfig = {
      Persistent = lib.mkForce false;
      RandomizedDelaySec = lib.mkForce 0;
    };
  };

  flake.modules.darwin.base = {
    /*
      TODO: Is determinate... worth it?
      inherit nix;
    */
  };
}
