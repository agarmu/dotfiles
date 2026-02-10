let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        tmux
        neovim
        wget
        rsync
        nix-search
      ];
    };
  # todo: please fix...
  nixosPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kbd
        alacritty
        wl-clipboard
        xwayland
        nix-search
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

    };
in
{
  flake.modules.nixos.base = {
    imports = [
      genericPackages
      nixosPackages
    ];
  };

  flake.modules.darwin.base = {
    imports = [
      genericPackages
    ];
  };
}
