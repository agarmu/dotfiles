let
  stdCommunication = { pkgs, ... }: {
    home.packages = [ pkgs.slack ];
    programs.discord = {
      enable = true;
    };
    stylix.targets.discord.enable = false;
  };
  aarch64Communication = { pkgs, ... }: {
    # SHAME ON SLACK !
    home.packages = [ pkgs.mukul.slk ];
    # SHAME ON DISCORD!
    programs.vesktop = {
      enable = true;
      settings = {
        minimizeToTray = false;
        hardwareAcceleration = true;
      };
    };
    stylix.targets.vesktop.enable = false;

  };
in
{
  flake.modules.homeManager.gui = { pkgs, ... }: {
    imports =
      if (pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64) then
        [ aarch64Communication ]
      else
        [ stdCommunication ];
  };
}
