{ lib, ... }:
let
  blacklistPath = "/etc/dnscrypt/mybase.txt";
in
{
  flake.modules.nixos.base = {
    networking.nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networking.networkmanager.dns = lib.mkForce "none";
    networking.dhcpcd.extraConfig = "nohook resolv.conf";
    services.resolved.enable = lib.mkForce false;

    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        };

        ipv6_servers = true;
        block_ipv6 = false;

        require_dnssec = true;
        require_nolog = false;
        require_nofilter = true;

        # todo: find a wider range of dns resolvers
        server_names = [ "cloudflare" ];
        forwarding_rules = "${./forwarding.txt}";
        blocked_names.blocked_names_file = blacklistPath;
      };
    };

    systemd.tmpfiles.rules = [
      "d /etc/dnscrypt 0755 root root -"
      "f ${blacklistPath} 0755 root root -"
    ];

    systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = "dnscrypt-proxy";
  };
}
