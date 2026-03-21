{ lib, ... }:
{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.niri.settings =
        let
          shader = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/sodiboo/system/main/personal/resize.glsl";
            hash = "sha256-mSvGXUuPKl1f1ub1ypx+e8ugTtsx+8OQfx1Ft3dl/B0=";
          };
        in
        {
          xwayland-satellite = {
            enable = true;
            path = lib.getExe pkgs.xwayland-satellite-unstable;
          };

          animations.window-resize.custom-shader = builtins.readFile shader;
          screenshot-path = "~/Downloads/Screenshot from %Y-%m-%d %H-%M-%S.png";
        };
    };
}
