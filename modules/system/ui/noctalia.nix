{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.nixosGui = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.niri.settings.spawn-at-startup = [
      { argv = [ "noctalia-shell" ]; }
    ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = {
        general = {
          telemetryEnabled = false;
          showChangelogOnStartup = false;
        };

        colorSchemes = {
          darkMode = true;
          useWallpaperColors = false;
        };

        appLauncher = {
          terminalCommand = "alacritty";
          sortByMostUsed = true;
        };
      };
    };
  };
}
