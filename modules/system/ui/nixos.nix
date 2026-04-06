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
          pkgs.mukul.pixie-sddm
          kdePackages.qtdeclarative
          kdePackages.qtsvg
        ];

        # required explicitly: SDDM needs either xserver or wayland enabled,
        # and wayland mode is broken (kwin has no mouse, weston has no easy HiDPI).
        services.xserver.enable = true;

        services.displayManager.sddm = {
          enable = true;
          # see: https://www.reddit.com/r/kde/comments/1oyfs61/how_do_i_change_the_scaling_of_the_sddm_login/
          settings.General.GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
          theme = "pixie";
        };
        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
    };
}
