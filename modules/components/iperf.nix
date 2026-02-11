{
  flake.modules.nixos.base = {
    services.iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
