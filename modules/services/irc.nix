_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    services.soju = {
      enable = true;
      hostName = "millet.agarmu.com";
      listen = [ ":6697" ];
      tlsCertificate = "%d/fullchain.pem";
      tlsCertificateKey = "%d/key.pem";
    };
    systemd.services.soju.serviceConfig = {
      LoadCredential = [
        "fullchain.pem:/var/lib/acme/millet.agarmu.com/fullchain.pem"
        "key.pem:/var/lib/acme/millet.agarmu.com/key.pem"
      ];
    };
    networking.firewall.allowedTCPPorts = [ 6697 ];
  };
}
