_: {
  flake.modules.nixos.host-millet = {
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    sops.age.generateKey = false;

    sops.secrets."cloudflare-dns-token" = {
      owner = "acme";
    };
    sops.secrets."grafana-secret-key" = {
      owner = "grafana";
    };
    sops.secrets."grafana-admin-password" = {
      owner = "grafana";
    };
    sops.secrets."prometheus-web-config" = {};
    sops.secrets."loki-auth-token" = {};
  };
}
