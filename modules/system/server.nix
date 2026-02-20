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
    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
