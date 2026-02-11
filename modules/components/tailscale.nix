{ lib, ... }:
{
  flake.modules.nixos.base = {
    services.tailscale = {
      /*
        don't override other firewall rules
        https://nixos.wiki/wiki/Tailscale
      */
      enable = true;
      extraSetFlags = [ "--netfilter-mode=nodivert" ];
    };
  };
  flake.modules.darwin.base = {
    services.tailscale.enable = true;
  };
}
