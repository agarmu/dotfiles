{ lib, ... }:
{
  flake.modules.nixos.useMilletBuilder =
    { config, ... }:
    {
      nix.distributedBuilds = true;
      nix.buildMachines = lib.mkIf (config.networking.hostName != "millet") [
        {
          hostName = "millet";
          systems = [ "aarch64-linux" ];
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
          protocol = "ssh-ng";
          maxJobs = 4;
          speedFactor = 16;
          sshUser = "mukul";
        }
      ];
    };
}
