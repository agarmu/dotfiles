# System services configuration
{ inputs, pkgs, ... }:
{
  flake.modules.nixos.gui = {
    # enable greeter service
    services.greetd = {
      enable = true;
      settings.default_session = {
        user = "greeter";
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet --cmd niri
        '';
      };
    };
    # enable compositor
    programs.niri = {
      enable = false;
    };
    # enable xdg features
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

}
