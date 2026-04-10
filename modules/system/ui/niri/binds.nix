_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.binds = {
      "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

      "Mod+T" = {
        hotkey-overlay.title = "Terminal";
        action.spawn = [ "alacritty" ];
      };
      "Mod+Space" = {
        hotkey-overlay.title = "Launcher";
        action.spawn-sh = [ "pkill fuzzel || fuzzel" ];
      };
      "Mod+N" = {
        hotkey-overlay.title = "Notifications";
        action.spawn = [
          "swaync-client"
          "-t"
        ];
      };
      "Mod+Alt+L" = {
        hotkey-overlay.title = "Session";
        action.spawn = [ "wleave" ];
      };

      "Mod+Shift+S" = {
        hotkey-overlay.title = "Screenshot";
        action.screenshot = [ ];
      };
      "Mod+Shift+Ctrl+S" = {
        hotkey-overlay.title = "Screenshot window";
        action.screenshot-window = [ ];
      };
      "Mod+D" = {
        hotkey-overlay.title = "Toggle tabbed";
        action.toggle-column-tabbed-display = [ ];
      };

      "XF86AudioRaiseVolume".action.spawn = [
        "volumectl"
        "-u"
        "up"
      ];
      "XF86AudioLowerVolume".action.spawn = [
        "volumectl"
        "-u"
        "down"
      ];
      "XF86AudioMute".action.spawn = [
        "volumectl"
        "toggle-mute"
      ];
      "XF86AudioMicMute".action.spawn = [
        "volumectl"
        "-m"
        "toggle-mute"
      ];
      "XF86AudioNext".action.spawn = [
        "playerctl"
        "next"
      ];
      "XF86AudioPrev".action.spawn = [
        "playerctl"
        "previous"
      ];
      "XF86AudioPlay".action.spawn = [
        "playerctl"
        "play-pause"
      ];
      "XF86MonBrightnessUp".action.spawn = [
        "lightctl"
        "up"
      ];
      "XF86MonBrightnessDown".action.spawn = [
        "lightctl"
        "down"
      ];
      "XF86LaunchA".action.spawn-sh = [ "pkill fuzzel || fuzzel" ];
      "XF86Sleep".action.spawn = [ "swaylock" ];

      "Mod+Q" = {
        hotkey-overlay.title = "Close window";
        action.close-window = [ ];
      };

      "Mod+Left".action.focus-column-left = [ ];
      "Mod+Down".action.focus-window-down = [ ];
      "Mod+Up".action.focus-window-up = [ ];
      "Mod+Right".action.focus-column-right = [ ];
      "Mod+H" = {
        hotkey-overlay.title = "Focus left";
        action.focus-column-left = [ ];
      };
      "Mod+J" = {
        hotkey-overlay.title = "Focus down";
        action.focus-window-down = [ ];
      };
      "Mod+K" = {
        hotkey-overlay.title = "Focus up";
        action.focus-window-up = [ ];
      };
      "Mod+L" = {
        hotkey-overlay.title = "Focus right";
        action.focus-column-right = [ ];
      };

      "Mod+Ctrl+Left".action.move-column-left = [ ];
      "Mod+Ctrl+Down".action.move-window-down = [ ];
      "Mod+Ctrl+Up".action.move-window-up = [ ];
      "Mod+Ctrl+Right".action.move-column-right = [ ];
      "Mod+Ctrl+H" = {
        hotkey-overlay.title = "Move column left";
        action.move-column-left = [ ];
      };
      "Mod+Ctrl+J" = {
        hotkey-overlay.title = "Move window down";
        action.move-window-down = [ ];
      };
      "Mod+Ctrl+K" = {
        hotkey-overlay.title = "Move window up";
        action.move-window-up = [ ];
      };
      "Mod+Ctrl+L" = {
        hotkey-overlay.title = "Move column right";
        action.move-column-right = [ ];
      };

      "Mod+U" = {
        hotkey-overlay.title = "Workspace down";
        action.focus-workspace-down = [ ];
      };
      "Mod+I" = {
        hotkey-overlay.title = "Workspace up";
        action.focus-workspace-up = [ ];
      };

      "Mod+Ctrl+U" = {
        hotkey-overlay.title = "Move to workspace down";
        action.move-column-to-workspace-down = [ ];
      };
      "Mod+Ctrl+I" = {
        hotkey-overlay.title = "Move to workspace up";
        action.move-column-to-workspace-up = [ ];
      };

      "Mod+Shift+U" = {
        hotkey-overlay.title = "Shift workspace down";
        action.move-workspace-down = [ ];
      };
      "Mod+Shift+I" = {
        hotkey-overlay.title = "Shift workspace up";
        action.move-workspace-up = [ ];
      };

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      "Mod+Comma" = {
        hotkey-overlay.title = "Consume into column";
        action.consume-window-into-column = [ ];
      };
      "Mod+Period" = {
        hotkey-overlay.title = "Expel from column";
        action.expel-window-from-column = [ ];
      };

      "Mod+R" = {
        hotkey-overlay.title = "Cycle column width";
        action.switch-preset-column-width = [ ];
      };
      "Mod+F" = {
        hotkey-overlay.title = "Maximize column";
        action.maximize-column = [ ];
      };
      "Mod+Shift+F" = {
        hotkey-overlay.title = "Fullscreen";
        action.fullscreen-window = [ ];
      };
      "Mod+C" = {
        hotkey-overlay.title = "Center column";
        action.center-column = [ ];
      };

      "Mod+Minus" = {
        hotkey-overlay.title = "Shrink column";
        action.set-column-width = "-10%";
      };
      "Mod+Equal" = {
        hotkey-overlay.title = "Grow column";
        action.set-column-width = "+10%";
      };

      "Mod+Shift+Minus" = {
        hotkey-overlay.title = "Shrink window";
        action.set-window-height = "-10%";
      };
      "Mod+Shift+Equal" = {
        hotkey-overlay.title = "Grow window";
        action.set-window-height = "+10%";
      };

      "Mod+Shift+E" = {
        hotkey-overlay.title = "Quit";
        action.quit = [ ];
      };
      "Mod+Shift+P" = {
        hotkey-overlay.title = "Power off monitors";
        action.power-off-monitors = [ ];
      };
    };
  };
}
