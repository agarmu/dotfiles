{ lib, ... }:
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      networking = {
        /*
          	   first, let us set up the firewall

          	   trust ONLY the tailscale0 interface
          	   for incoming connections, a priori
        */
        nftables.enable = true;
        firewall = {
          enable = true;
          # Always allow traffic from your Tailscale network
          trustedInterfaces = [ "tailscale0" ];
          # Allow the Tailscale UDP port through the firewall
          allowedUDPPorts = [ config.services.tailscale.port ];
        };
        # tool to manage networks. very useful
        networkmanager.enable = true;
      };
    };
  # wi-fi should be available on mobile systems
  flake.modules.nixos.mobile = _: {
    networking = {
      wireless.iwd = {
        enable = true;
        settings = {
          Network.EnableIPv6 = true;
          Settings.AutoConnect = true;
          General.EnableNetworkConfiguration = true;
        };
      };
      networkmanager.wifi.backend = "iwd";

    };
    /*
      little utility to connect to `captive`
               browser portals, without ruining our
      	 dns settings
    */
    programs.captive-browser = {
      enable = true;
      interface = "wlan0";
    };
  };
}
