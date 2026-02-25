{ inputs, ... }:
{
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];
      environment.systemPackages = with pkgs; [
        kbd
        wl-clipboard
        xwayland
        brightnessctl
        mako
      ];

      services.displayManager.dms-greeter = {
      	enable = true;
	compositor.name = "niri";
	package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
