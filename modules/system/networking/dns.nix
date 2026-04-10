{ lib, ... }:
{
  flake.modules.nixos.base = _: {
    networking.nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    networking.networkmanager.dns = lib.mkForce "systemd-resolved";

    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = "true";
        DNSSEC = "true";
        FallbackDNS = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];

      };
    };
  };
}
