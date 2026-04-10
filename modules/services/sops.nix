{ inputs, rootDir, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.base = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = false;
  };
  flake.modules.nixos.host-millet = {
    sops.defaultSopsFile = "${rootDir}/secrets/millet.yaml";
    sops.secrets."cloudflare-dns-token" = {
      owner = "acme";
    };
  };

  flake.modules.nixos.host-wheat = {
    sops.defaultSopsFile = "${rootDir}/secrets/wheat.yaml";
  };
}
