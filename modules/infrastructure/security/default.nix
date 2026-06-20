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
          fusermount.enable = lib.mkForce false;
          fusermount3.enable = lib.mkForce false;
          pkexec.setuid = lib.mkForce false;
          newgrp.setuid = lib.mkForce false;
          newgidmap.setuid = lib.mkForce false;
          newuidmap.setuid = lib.mkForce false;
          mount.enable = lib.mkForce false;
          umount.enable = lib.mkForce false;
        };
        pki.certificates = [
          (builtins.readFile ./millet.crt)
        ];

        pam.services.login.kwallet.enable = true;
      };
    };
}
