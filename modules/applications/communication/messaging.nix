{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      needsShamefulConfig = pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64;
    in
    {
      home.packages = [ (if needsShamefulConfig then pkgs.mukul.slk else pkgs.slack) ];
      # SHAME ON DISCORD!
      programs.vesktop = {
        enable = needsShamefulConfig;
        settings = {
          minimizeToTray = false;
          hardwareAcceleration = true;
        };
      };
      programs.discord.enable = !needsShamefulConfig;
      stylix.targets.vesktop.enable = false;
    };
}
