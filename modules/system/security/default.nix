_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cacert
        libsecret # secret-tool CLI
        libseccomp
      ];

      # sudo-rs: Rust reimplementation of sudo
      security.sudo.enable = false;
      security.sudo-rs.enable = true;

      security.pki.certificates = [
        (builtins.readFile ./millet.crt)
      ];

      # Soteria: freedesktop security agent for Wayland
      security.soteria.enable = true;
      # GNOME Keyring
      services.gnome.gnome-keyring.enable = true;
    };

  flake.modules.darwin.base = {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
  };
}
