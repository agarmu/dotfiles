{ lib, ... }: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cacert
        libsecret # secret-tool CLI
        libseccomp
        kdePackages.kwallet # KDE secret service daemon (D-Bus activated)
      ];

      services.logrotate.enable = true;

      # sudo-rs: Rust reimplementation of sudo
      security = {
        sudo.enable = lib.mkForce false;
        sudo-rs.enable = lib.mkForce false;
        run0 = {
          enableSudoAlias = true;
        };
        polkit.enable = true;
        wrappers = {
          unix_chkpwd.enable = lib.mkForce true;
          su.enable = lib.mkForce false;
          sg.enable = lib.mkForce false;
          fusermount.enable = lib.mkDefault false;
          fusermount3.enable = lib.mkDefault false;
          pkexec.setuid = lib.mkForce false;
          newgrp.setuid = lib.mkForce false;
          newgidmap.setuid = lib.mkForce false;
          newuidmap.setuid = lib.mkForce false;
          mount.enable = lib.mkDefault false;
          umount.enable = lib.mkDefault false;
        };
        pki.certificates = [
          (builtins.readFile ./millet.crt)
        ];

        pam.services.login.kwallet.enable = true;
      };
    };
  flake.modules.nixos.gui = {
    security.wrappers = {
      fusermount.enable = lib.mkForce true;
      fusermount3.enable = lib.mkForce true;
      mount.enable = lib.mkForce true;
      umount.enable = lib.mkForce true;
    };
  };
}
