{ inputs, lib, ... }:
{
  flake.modules.nixos.base =
    { ... }:
    {
      networking = {
        nftables.enable = true;
        firewall.enable = true;
        # tool to manage networks. very useful
        networkmanager.enable = true;
        modemmanager.enable = lib.mkForce false;
        nameservers = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
          "2606:4700:4700::1001#cloudflare-dns.com"
        ];
      };
      services.resolved = {
        enable = true;
        dnsovertls = "opportunistic";
        dnssec = "allow-downgrade";
        domains = [ "~." ];
      };
    };
  # wi-fi should be available on mobile systems
  flake.modules.nixos.mobile = {
    imports = [ inputs.self.modules.nixos.wifi ];
  };
}
