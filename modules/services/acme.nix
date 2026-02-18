_: {
  # enable only on host millet
  flake.modules.nixos.host-millet = {
    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@agarmu.com";
      certs."millet.agarmu.com" = {
        # default is HTTP-01; nginx integration below serves the challenge
        webroot = "/var/lib/acme/acme-challenge";
        group = "acme";
      };
    };
    users.users.nginx.extraGroups = [ "acme" ];
    services.nginx = {
      enable = true;
      virtualHosts."millet.agarmu.com" = {
        # makes nginx serve /.well-known/acme-challenge/*
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true; # if your app uses websockets
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
