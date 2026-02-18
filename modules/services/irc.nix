_: {
  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      services.soju =
        let
          tlsDir = config.security.acme.certs."millet.agarmu.com".directory;
        in
        {
          enable = true;
          hostName = "millet.agarmu.com";
          listen = [ ":6697" ];
          tlsCertificate = "${tlsDir}/fullchain.pem";
          tlsCertificateKey = "${tlsDir}/key.pem";
        };
      users.users.soju.extraGroups = [ "acme" ];
      networking.firewall.allowedTCPPorts = [ 6697 ];
    };
}
