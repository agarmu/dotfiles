_: {
  flake.modules.nixos.host-millet = {
    services.caddy.virtualHosts."agarmu.com" = {
      extraConfig = ''
        redir https://www.agarmu.com{uri} permanent
      '';
    };
  };
}
