{ lib, ... }:
{
  flake.modules.nixos.server = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    users.users.mukul.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIg0QnqdlIbqa03vuqds4mN95fi5tR1tBCAUhbAIpMF8 mukul@wheat"
    ];

    # Disable autologin.
    services.getty.autologinUser = null;
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "2h";
      bantime-increment = {
        rndtime = "8m";
        factor = "3";
      };
    };

    services.logrotate.enable = true;
    security.auditd.enable = true;
  };

  flake.modules.nixos.host-millet =
    let
      port = 2350;
    in
    {
      services.openssh.ports = lib.mkForce [ port ];
      networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ port ];
    };
}
