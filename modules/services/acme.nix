_: {
  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@agarmu.com";
        dnsProvider = "cloudflare";
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."cloudflare-dns-token".path;
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
