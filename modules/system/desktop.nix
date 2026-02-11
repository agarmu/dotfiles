{ lib, inputs, ... }:
{
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.gui = {pkgs, ...}: {
    imports = [
      inputs.niri.nixosModules.niri
    ];
    environment.systemPackages = with pkgs; [
      kbd
      wl-clipboard
      xwayland
      fuzzel # launcher - wayland
      brightnessctl
      mako
      swaylock
      waybar
    ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        xwayland-satelite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };
      };
    };
  };
  flake.modules.darwin.gui = {
    system.defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      dock = {
        autohide = false;
        show-recents = false; # disable recent apps
      };
      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = true; # enable when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
      NSGlobalDomain = {
        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
    };
  };
}
