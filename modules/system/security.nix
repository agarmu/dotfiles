{ lib, ... }:
{
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

      # Soteria: freedesktop security agent for Wayland
      security.soteria.enable = true;
      # GNOME Keyring
      services.gnome.gnome-keyring.enable = true;
    };
  flake.modules.homeManager.nixosGui = {
    # we use soteria instead.
    systemd.user.services.niri-flake-polkit.Install.WantedBy = lib.mkForce [ ];
  };
  flake.modules.darwin.base = {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
  };
}
