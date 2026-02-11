{ lib, ... }:
{
  flake.modules.nixos.base = {

  };
  flake.modules.darwin.base = {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
    # TODO: add certs to blacklist
    security.pki.caCertificateBlacklist = [ ];
  };
}
