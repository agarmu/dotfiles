_: {
  flake.modules.nixos.host-millet = {
    services.grocy = {
      enable = true;
      hostName = "grocy.agarmu.com";
    };
  };
}
