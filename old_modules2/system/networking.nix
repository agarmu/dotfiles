# Networking configuration
{ lib, config, ... }:
{
  flake.modules.nixos.base = {
    networking.wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    networking.networkmanager.enable = lib.mkDefault true;
  };
  flake.modules.nixos.asahi = {
    # asahi does not play well with nmcli
    networking.networkmanager.enable = lib.mkForce false;
  };
}
