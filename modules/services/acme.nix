_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@agarmu.com";
        dnsProvider = "cloudflare";
        # TODO: Move to sops-nix for secret management
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = "/var/lib/acme/cloudflare.env";
        };
      };
      certs."agarmu.com" = {
        domain = "agarmu.com";
        extraDomainNames = [
          "irc.agarmu.com"
          "dash.agarmu.com"
        ];
        group = "nginx";
      };
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
