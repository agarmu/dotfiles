{
  flake.modules.homeManager.gui =
    { pkgs, ... }:

    {
      home.packages = with pkgs; lib.mkIf (lib.meta.availableOn stdenv.hostPlatform slack) [ slack ];
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mukul.slk ];
      programs.vesktop = {
        enable = true;
        settings = {
          minimizeToTray = false;
          hardwareAcceleration = true;
        };
      };
      stylix.targets.vesktop.enable = false;
    };
}
