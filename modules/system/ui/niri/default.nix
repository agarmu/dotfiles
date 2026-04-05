{ lib, ... }:
{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.niri.settings = {
        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite-unstable;
        };
        screenshot-path = "~/Pictures/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      };
    };
}
