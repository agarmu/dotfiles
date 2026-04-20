{
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
      security.sudo.enable = false;
      security.sudo-rs.enable = true;

      security.pki.certificates = [
        (builtins.readFile ./millet.crt)
      ];

      security.polkit.enable = true;

      # Soteria: freedesktop security agent for Wayland
      security.soteria.enable = true;
      # KWallet: PAM auto-unlock on login
      security.pam.services.login.kwallet.enable = true;
    };

  flake.modules.darwin.base = {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
  };
}
