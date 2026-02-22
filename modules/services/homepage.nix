_: {
  flake.modules.nixos.host-millet = {
    services.nginx.virtualHosts."agarmu.com" = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "www.agarmu.com";
    };
  };
}
