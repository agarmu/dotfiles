let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        tmux
        nano
      ];
    };
  # todo: please fix...
  nixosPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        acpi
        kbd
        alacritty
        wl-clipboard
        xwayland
        nix-search
        wget
        rsync
        fuzzel # launcher - wayland
        brightnessctl
        mako
        swaylock
        zed-editor
        light
        bitwarden-desktop
        bitwarden-cli
        waybar
      ];
      fonts.packages = with pkgs; [
        inconsolata
        cascadia-code
        cm_unicode
        lmodern
      ];
    };
in
{
  flake.modules.nixos.cli-tools = {
    imports = [
      genericPackages
      nixosPackages
    ];
  };

  flake.modules.darwin.cli-tools = {
    imports = [
      genericPackages
    ];
  };
}
