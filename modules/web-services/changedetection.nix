{
  flake.modules.nixos.base.web-services.change = {
    host = "millet";
    port = 5000;
  };

  flake.modules.nixos.host-millet = {
    services.changedetection-io = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 5000;
    };
  };
}
