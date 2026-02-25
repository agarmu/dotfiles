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
        enableSystemMonitoring = true;
        enableAudioWavelength = true;
        enableClipboardPaste = true;
        settings = {
          wallpaper = "${pkgs.pop-wallpapers}/share/backgrounds/pop/benjamin-voros-250200.jpg";
        };
      };
    };
}
