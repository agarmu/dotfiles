{ lib, ... }:
{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    let
      serialNumber = 1;
      zoneFile = pkgs.writeTextFile {
        name = "internal.zone";
        text = ''
          $ORIGIN internal.
          $TTL 3600
          @  IN SOA ns.internal. admin.internal. ${toString serialNumber} 3600 1200 604800 3600
          @  IN NS  ns.internal.
          ns IN A   127.0.0.1
        ''
        + (
          config.networking.extraProxies
          |> lib.mapAttrsToList (name: target: "${lib.removeSuffix ".internal" name} IN CNAME ${target}.")
          |> lib.concatStringsSep "\n"
        )
        + "\n";
      };
    in
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
          };

          auth-zone = [
            {
              name = "internal";
              zonefile = "${zoneFile}";
              for-downstream = false;
              for-upstream = true;
            }
          ];
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
              forward-addr = [ "127.0.0.1@12036" ];
              forward-no-cache = false;
            }
          ];
        };
      };
      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          listen_addresses = [ "127.0.0.1:12036" ];
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
