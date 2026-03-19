{ inputs, ... }:
{
  /*
    Do NOT change package = pkgs.niri-unstable to pkgs.niri
    so long as the latest Niri update is (25.11) --- this is because
    the system we are using relies on fixes post-25.11 to work
    properly. But, we don't want to continuously incur rebuilding cost
    so we just pin to this revision.

    TODO: When niri cuts a new release (> 25.11), then:
      (a) use the package from stable nixpkgs instead of the flake-provided one.
      (b) stop depending on this flake.
  */
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake/5336c8d137d1a3ad055e83fa08dcb17c1f2b9444";
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
      ];
      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
