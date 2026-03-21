{ lib, ... }:
let
  wallpaper = {
    name = "firewatch-wide";
    url = "https://w.wallhaven.cc/full/o3/wallhaven-o3r9p7.png";
    hash = "sha256-IN1+5sIyuSOEilxsq/v5gxsSdCYCT3ZGrp0IzY64ICo=";
  };
in
{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    let
      source = pkgs.fetchurl {
        inherit (wallpaper) url hash;
        name = "${wallpaper.name}.png";
      };
      blurred = pkgs.runCommand "${wallpaper.name}-blurred" { } ''
        mkdir -p $out
        ${pkgs.bgutils}/bin/bgutils blur ${source} $out/blurred.png
      '';
    in
    {
      environment.etc."greeter-wallpaper".source = "${blurred}/blurred.png";
    };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      source = pkgs.fetchurl {
        inherit (wallpaper) url hash;
        name = "${wallpaper.name}.png";
      };
      blurred = pkgs.runCommand "${wallpaper.name}-blurred" { } ''
        mkdir -p $out
        ${pkgs.bgutils}/bin/bgutils blur ${source} $out/blurred.png
      '';
      modulated = pkgs.runCommand "${wallpaper.name}-modulated" { } ''
        mkdir -p $out
        ${pkgs.bgutils}/bin/bgutils modulate ${source} $out/modulated.png
      '';
    in
    {
      xdg.dataFile = {
        "wallpapers/${wallpaper.name}/base.png".source = source;
        "wallpapers/${wallpaper.name}/blurred.png".source = "${blurred}/blurred.png";
        "wallpapers/${wallpaper.name}/modulated.png".source = "${modulated}/modulated.png";
      };

      home.packages = with pkgs; [ swww ];

      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        layout.background-color = "transparent";
        layer-rules = [
          {
            place-within-backdrop = true;
          }
        ];

        spawn-at-startup = [
          {
            argv = [
              "swww-daemon"
              "-l"
              "bottom"
              "-n"
              "bg"
            ];
          }
          {
            argv = [
              "swww-daemon"
              "-l"
              "background"
              "-n"
              "overview"
            ];
          }
          {
            argv = [
              "swww"
              "img"
              "-n"
              "bg"
              "${source}"
            ];
          }
          {
            argv = [
              "swww"
              "img"
              "-n"
              "overview"
              "${blurred}/blurred.png"
            ];
          }
        ];
      };
    };
}
