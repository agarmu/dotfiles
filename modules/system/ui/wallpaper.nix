_:
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
      source = "${pkgs.pop-wallpapers}/share/backgrounds/pop/benjamin-voros-250200.jpg";
      wallpaper-dir = pkgs.mukul.mkWallpaper { src = source; };
    in
    {
      environment.etc."greeter-wallpaper".source = "${wallpaper-dir}/blurred.jpg";
    };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      source = "${pkgs.pop-wallpapers}/share/backgrounds/pop/benjamin-voros-250200.jpg";
      wallpaper-dir = pkgs.mukul.mkWallpaper { src = source; };
    in
    {
      xdg.dataFile = {
        "wallpapers/${wallpaper.name}/base.png".source = "${wallpaper-dir}/original.jpg";
        "wallpapers/${wallpaper.name}/blurred.png".source = "${wallpaper-dir}/blurred.jpg";
      };

      home.packages = with pkgs; [ swww ];

      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        layout.background-color = "transparent";
        layer-rules = [
          {
            matches = [
              { namespace = "^swww.*$"; }
            ];
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
              "${wallpaper-dir}/original.jpg"
            ];
          }
          {
            argv = [
              "swww"
              "img"
              "-n"
              "overview"
              "${wallpaper-dir}/blurred.jpg"
            ];
          }
        ];
      };
    };
}
