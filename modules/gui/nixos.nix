{ inputs, ... }:
{
  /*
    Do NOT change package = pkgs.niri-unstable to pkgs.niri
    so long as the latest Niri update is (25.11) --- this is because
    the system we are using relies on fixes post-25.11 to work
    properly.

    TODO: When niri cuts a new release (> 25.11), then:
      (a) use the package from stable nixpkgs instead of the flake-provided one.
      (b) stop depending on this flake.
  */
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
      nix.settings = {
        substituters = [
          "https://niri-nix.cachix.org"
        ];
        trusted-public-keys = [
          "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        ];
      };
      nixpkgs.overlays = [ inputs.niri-nix.overlays.niri-nix ];

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
        useNautilus = true;
      };
    };
}
