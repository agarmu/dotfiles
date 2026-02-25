{ inputs, ... }:
{
  flake-file.inputs.dms = {
    url = "github:AvengeMedia/DankMaterialShell/stable";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.gui = {
    systemd.user.services.niri-flake-polkit.enable = false;
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];
      programs.dank-material-shell = {
        enable = true;
        systemd = {
          enable = true;
          restartIfChanged = true;
        };
        niri = {
          enableKeybinds = true;
          enableSpawn = false;
        };
        enableDynamicTheming = false;
        enableSystemMonitoring = false;
        enableAudioWavelength = true;
        enableClipboardPaste = true;
        settings = {
          wallpaper = "${pkgs.pop-wallpapers}/share/backgrounds/pop/benjamin-voros-250200.jpg";
          showLauncherButton = false;
          showClipboard = false;
          showCpuUsage = false;
          showMemUsage = false;
          showCpuTemp = false;
          showGpuTemp = false;
          showWorkspaceSwitcher = false;
          showFocusedWindow = false;
          showSystemTray = false;
          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = 0;
              screenPreferences = [ "all" ];
              showOnLastDisplay = true;
              leftWidgets = [
                "music"
                "clock"
                "weather"
              ];
              centerWidgets = [ ];
              rightWidgets = [
                "notificationButton"
                "battery"
                "controlCenterButton"
              ];
            }
          ];
        };
      };
    };
}
