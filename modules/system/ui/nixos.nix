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
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixpkgs-stable.follows = "nixpkgs";
  };
  flake.modules.nixos.gui =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      config = {
        environment.systemPackages = with pkgs; [
          kbd
          wl-clipboard
          brightnessctl
          grim
          satty
          wayland
          wdisplays
        ];

        services.displayManager.gdm = {
          enable = true;
          wayland = true;
        };

        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
    };
}
