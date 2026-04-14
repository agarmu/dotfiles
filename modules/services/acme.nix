_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    services.caddy = {
      enable = true;
      email = "acme@agarmu.com";
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
