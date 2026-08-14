{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      needsShamefulConfig = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isAarch64;
    in
    {
      home.packages = [ (if needsShamefulConfig then pkgs.slk else pkgs.slack) ];
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
