{ lib, ... }:
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      networking.nameservers = [
        "127.0.0.1"
        "::1"
      ];
      networking.networkmanager.dns = lib.mkForce "none";
      networking.dhcpcd.extraConfig = "nohook resolv.conf";
      services.resolved.enable = lib.mkForce false;

      services.unbound = {
        enable = true;
        settings = {
          server = {
            interface = [
              "127.0.0.1"
              "::1"
            ];
            port = 53;
            access-control = [
              "127.0.0.0/8 allow"
              "::1/128 allow"
            ];

            num-threads = 2;
            do-ip6 = true;
            prefer-ip6 = false;
            do-not-query-localhost = false;

            private-domain = [
              "internal"
              "ts.net"
            ];

            domain-insecure = [
              "internal"
              "ts.net"
            ];

            local-zone = [
              "internal. transparent"
            ];

            local-data = lib.mapAttrsToList (
              domain: target: ''"${domain}. IN CNAME ${target}."''
            ) config.networking.extraProxies;
          };

          stub-zone = [
            {
              name = "ts.net";
              stub-addr = "100.100.100.100";
              stub-no-cache = true;
            }
            {
              name = "100.in-addr.arpa";
              stub-addr = "100.100.100.100";
              stub-no-cache = true;
            }
          ];

          forward-zone = [
            {
              name = ".";
              forward-addr = [ "127.0.0.1@5353" ];
              forward-no-cache = false;
            }
          ];
        };
      };
      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          listen_addresses = [ "127.0.0.1:5353" ];
          cache = false;
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
        };
      };
      systemd.services.dnscrypt-proxy.serviceConfig.StateDirectory = "dnscrypt-proxy";
    };
}
