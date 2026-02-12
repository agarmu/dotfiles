{ inputs, ... }:
{
  flake.modules.nixos.base = {
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

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
