_: {
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kbd
        wl-clipboard
        xwayland
        brightnessctl
      ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
}
