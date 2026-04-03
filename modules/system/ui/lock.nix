_: {
  flake.modules.homeManager.nixosGui = {
    programs.niri.settings.binds = {
      "Mod+Alt+P" = {
        hotkey-overlay.title = "Lock + Suspend";
        action.spawn-sh = "noctalia-shell ipc call lockScreen lock && systemctl suspend";
      };

      "Mod+Alt+L" = {
        hotkey-overlay.title = "Lock";
        action.spawn-sh = "noctalia-shell ipc call lockScreen lock";
      };
    };

    programs.noctalia-shell.settings.idle = {
      enabled = true;
      screenOffTimeout = 300;
      lockTimeout = 360;
      suspendTimeout = 1800;
    };
  };
}
