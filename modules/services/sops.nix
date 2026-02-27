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
    sops.secrets."paperless-admin-password" = {
      owner = "paperless";
    };
    sops.secrets."rclone/paperless/remote" = {
      owner = "rclone";
      group = "rclone";
    };
    sops.secrets."rclone/paperless/account" = {
      owner = "rclone";
      group = "rclone";
    };
    sops.secrets."rclone/paperless/key" = {
      owner = "rclone";
      group = "rclone";
    };
  };
}
