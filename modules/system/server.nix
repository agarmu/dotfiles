_: {
  flake.modules.nixos.server = {
    services.openssh = {
      enable = true;
      settings = {
        # PermitRootLogin = "no";
        # PasswordAuthentication = false;
      };
    };

    # Disable autologin.
    services.getty.autologinUser = null;
    documentation.enable = false;
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
    };

    services.logrotate.enable = true;

    security.auditd.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
