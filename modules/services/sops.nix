{ rootDir, ... }:
{
  flake.modules.nixos.host-millet = {
    sops.defaultSopsFile = "${rootDir}/secrets/millet.yaml";
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;

    sops.secrets."cloudflare-dns-token" = {
      owner = "acme";
    };
  };

  flake.modules.nixos.host-wheat = {
    sops.defaultSopsFile = "${rootDir}/secrets/wheat.yaml";
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = true;
  };
}
