{
  flake.modules.nixos.sshServer = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
    };
  };

  flake.modules.darwin.sshServer = {
    services.openssh = {
      enable = true;
    };
  };
}
