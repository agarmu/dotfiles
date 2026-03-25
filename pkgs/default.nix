pkgs:
let
  imgblur = pkgs.callPackage ./imgblur.nix { };
in
{
  mukul = {
    inherit imgblur;
    blurlock = pkgs.callPackage ./blurlock.nix { inherit imgblur; };
    niri-greeter = pkgs.callPackage ./niri-greeter.nix { };
    mkWallpaper = pkgs.callPackage ./wallpaper.nix { inherit imgblur; };
  };
}
