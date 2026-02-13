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
    security.pki.certificateFiles = [ ];
    security.pki.certificates = [ ];
    security.pki.installCACerts = true; # (usually default)
    environment.systemPackages = with pkgs; [ cacert ];
  };
}
