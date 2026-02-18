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
      networking.firewall.allowedTCPPorts = [ 6697 ];

      users.groups.soju = { };
      users.users.soju = {
        isSystemUser = true;
        group = "soju";
        extraGroups = [ "acme" ];
      };
    };
}
