_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    services.caddy = {
      enable = true;
      email = "acme@agarmu.com";
      extraConfig = ''
        (tailnet_only) {
          @not_tailnet not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
          respond @not_tailnet 403
        }
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
