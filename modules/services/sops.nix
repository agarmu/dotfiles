{ rootDir, ... }:
{
  flake.modules.nixos.host-millet = {
    sops.defaultSopsFile = "${rootDir}/secrets/millet.yaml";
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = false;

    sops.secrets."cloudflare-dns-token" = {
      owner = "acme";
    };
  };
}
