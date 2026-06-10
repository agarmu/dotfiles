{ ... }:
{
  flake.modules.nixos.base =
    { ... }:
    {
      networking.nameservers = [
        "1.1.1.1"
      ];
      services.resolved = {
        enable = true;
        dns = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
        ];
        domains = [ "~." ];
        dnsovertls = "opportunistic";
      };
    };
}
