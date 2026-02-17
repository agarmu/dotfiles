{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, config, ... }:
    {
      networking.wireless.iwd = {
        enable = true;
        settings = {
          Network.EnableIPv6 = true;
          Settings.AutoConnect = true;
          General.EnableNetworkConfiguration = true;
        };
      };
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };

      networking.nftables.enable = true;
      networking.firewall = {
        enable = true;
        # Always allow traffic from your Tailscale network
        trustedInterfaces = [ "tailscale0" ];
        # Allow the Tailscale UDP port through the firewall
        allowedUDPPorts = [ config.services.tailscale.port ];
      };

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };
}
