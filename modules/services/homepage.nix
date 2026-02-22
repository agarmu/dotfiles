_: {
  flake.modules.nixos.host-millet = {
    services.nginx.virtualHosts."agarmu.com" = {
      useACMEHost = "agarmu.com";
      forceSSL = true;
      globalRedirect = "www.agarmu.com";
    };
  };
}
