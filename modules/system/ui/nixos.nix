_: {
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
      ...
    }:
    let
      inherit (pkgs) lib;
      inherit (config.lib.stylix) colors;
      pixieSddm = pkgs.mukul.pixie-sddm.override {
        background = "/etc/wallpaper.png";
        primaryColor = "#${lib.toUpper colors.base0B}";
        accentColor = "#${lib.toUpper colors.base07}";
        backgroundColor = "#${lib.toUpper colors.base07}";
        textColor = "#${lib.toUpper colors.base00}";
        fontFamily = config.stylix.fonts.sansSerif.name;
        fontSize = config.stylix.fonts.sizes.desktop;
      };
    in
    {
      config = {
        environment.systemPackages = with pkgs; [
          kbd
          wl-clipboard
          brightnessctl
          grim
          satty
          wayland
          wdisplays
          pixieSddm
          config.stylix.cursor.package
        ];

        services.displayManager.sddm = {
          enable = true;
          enableHidpi = true;
          wayland.enable = true;
          wayland.compositor = "kwin";
          theme = "pixie";
          settings.Theme = {
            CursorTheme = config.stylix.cursor.name;
            CursorSize = config.stylix.cursor.size;
          };
        };
        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
    };
}
