{ lib, ... }:
let
  nix = {
    enable = lib.mkDefault true;
    gc = {
      automatic = true;
      options = lib.mkDefault "--delete-older-than 1w";
    };
    settings =
      let
        subs = [
          "https://cache.nixos.org"
          "https://cachix.org/api/v1/cache/nix-community"
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
    { pkgs, config, ... }:
    {
      nix = {
        package = pkgs.lix;
        buildMachines = lib.mkIf (config.networking.hostName != "millet") [
          {
            hostName = "millet";
            systems = [ "aarch64-linux" ];
            supportedFeatures = [
              "nixos-test"
              "benchmark"
              "big-parallel"
              "kvm"
            ];
            # protocol = "ssh-ng";
            maxJobs = 4;
            speedFactor = 16;
            sshUser = "mukul";

          }
        ];
      }
      // nix;
    };
  flake.modules.darwin.base = {
    /*
      TODO: Is determinate... worth it?
      inherit nix;
    */
  };
}
