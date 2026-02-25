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
        screenshot-path = "~/Downloads/Screenshot from %Y-%m-%d %H-%M-%S.png";
      };
    };
}
