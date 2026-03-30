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
      config,
      lib,
      ...
    }:
    let
      cfg = config.services.greetd.tuigreet;
      niri-session-bin = "/run/current-system/sw/bin/niri-session";
    in
    {
      options.services.greetd.tuigreet.windowPadding = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Window padding for tuigreet.";
      };

      imports = [
        inputs.niri.nixosModules.niri
      ];

      config = {
        environment.systemPackages = with pkgs; [
          kbd
          wl-clipboard
          xwayland
          brightnessctl
          grim
          satty
          wayland
          wdisplays
          rofi-bluetooth
          rofi-network-manager
        ];

        services.greetd = {
          enable = true;
          settings.default_session = {
            command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --time --window-padding ${toString cfg.windowPadding} --cmd ${niri-session-bin}";
            user = "greeter";
          };
        };

        security.pam.services.greetd.enableGnomeKeyring = true;

        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
    };

  flake.modules.nixos.host-wheat.services.greetd.tuigreet.windowPadding = 4;
}
