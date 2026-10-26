_: {
  flake.modules.nixos.gui =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        kbd
        wl-clipboard
        brightnessctl
        grim
        satty
        wayland
        wdisplays
      ];
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };

      programs.niri = {
        enable = true;
        package = pkgs.niri;
        useNautilus = true;
      };
    };
}
