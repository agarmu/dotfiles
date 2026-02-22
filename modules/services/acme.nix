_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@agarmu.com";
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
