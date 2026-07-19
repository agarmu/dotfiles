{ inputs, ... }:
{
  flake-file.inputs.niri-nix = {
    url = "git+https://codeberg.org/BANanaD3V/niri-nix.git";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.gui =
    {
      pkgs,
      config,
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
        config.stylix.cursor.package
      ];
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };

      imports = [
        inputs.niri-nix.nixosModules.default
      ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
        useNautilus = true;
      };
    };
}
