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
    { pkgs, config, ... }:
    let
      home-config = config.home-manager.users.mukul;
      kitty-config = toString home-config.xdg.configFile."kitty/kitty.conf".source;
      greeter = pkgs.mukul.niri-greeter { kittyConfig = kitty-config; };
    in
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];
      environment.systemPackages = with pkgs; [
        kbd
        wl-clipboard
        xwayland
        brightnessctl
        grim
        satty
      ];

      # greetd with niri-based greeter
      services.greetd = {
        enable = true;
        settings.default_session = {
          inherit (greeter) command;
          user = "greeter";
        };
      };

      security.pam.services.greetd.enableGnomeKeyring = true;

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
