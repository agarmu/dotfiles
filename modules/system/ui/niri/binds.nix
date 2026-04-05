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
        hotkey-overlay.title = "Lock screen";
        action.spawn = [ "blurlock" ];
      };

      "Mod+Shift+S" = {
        hotkey-overlay.title = "Screenshot";
        action.screenshot = [ ];
      };
      "Mod+D" = {
        hotkey-overlay.title = "Toggle tabbed";
        action.toggle-column-tabbed-display = [ ];
      };

      "XF86AudioRaiseVolume" = {
        hotkey-overlay.title = "Volume up";
        action.spawn = [
          "volumectl"
          "-u"
          "up"
        ];
      };
      "XF86AudioLowerVolume" = {
        hotkey-overlay.title = "Volume down";
        action.spawn = [
          "volumectl"
          "-u"
          "down"
        ];
      };
      "XF86AudioMute" = {
        hotkey-overlay.title = "Mute";
        action.spawn = [
          "volumectl"
          "toggle-mute"
        ];
      };
      "XF86AudioMicMute" = {
        hotkey-overlay.title = "Mic mute";
        action.spawn = [
          "volumectl"
          "-m"
          "toggle-mute"
        ];
      };

      "XF86MonBrightnessUp" = {
        hotkey-overlay.title = "Brightness up";
        action.spawn = [
          "lightctl"
          "up"
        ];
      };
      "XF86MonBrightnessDown" = {
        hotkey-overlay.title = "Brightness down";
        action.spawn = [
          "lightctl"
          "down"
        ];
      };

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

      "Mod+Home".action.focus-column-first = [ ];
      "Mod+End".action.focus-column-last = [ ];
      "Mod+Ctrl+Home".action.move-column-to-first = [ ];
      "Mod+Ctrl+End".action.move-column-to-last = [ ];

      "Mod+Shift+Left".action.focus-monitor-left = [ ];
      "Mod+Shift+Down".action.focus-monitor-down = [ ];
      "Mod+Shift+Up".action.focus-monitor-up = [ ];
      "Mod+Shift+Right".action.focus-monitor-right = [ ];
      "Mod+Shift+H" = {
        hotkey-overlay.title = "Focus monitor left";
        action.focus-monitor-left = [ ];
      };
      "Mod+Shift+J" = {
        hotkey-overlay.title = "Focus monitor down";
        action.focus-monitor-down = [ ];
      };
      "Mod+Shift+K" = {
        hotkey-overlay.title = "Focus monitor up";
        action.focus-monitor-up = [ ];
      };
      "Mod+Shift+L" = {
        hotkey-overlay.title = "Focus monitor right";
        action.focus-monitor-right = [ ];
      };

      "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
      "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
      "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
      "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
      "Mod+Shift+Ctrl+H" = {
        hotkey-overlay.title = "Move to monitor left";
        action.move-column-to-monitor-left = [ ];
      };
      "Mod+Shift+Ctrl+J" = {
        hotkey-overlay.title = "Move to monitor down";
        action.move-column-to-monitor-down = [ ];
      };
      "Mod+Shift+Ctrl+K" = {
        hotkey-overlay.title = "Move to monitor up";
        action.move-column-to-monitor-up = [ ];
      };
      "Mod+Shift+Ctrl+L" = {
        hotkey-overlay.title = "Move to monitor right";
        action.move-column-to-monitor-right = [ ];
      };

      "Mod+Page_Down".action.focus-workspace-down = [ ];
      "Mod+Page_Up".action.focus-workspace-up = [ ];
      "Mod+U" = {
        hotkey-overlay.title = "Workspace down";
        action.focus-workspace-down = [ ];
      };
      "Mod+I" = {
        hotkey-overlay.title = "Workspace up";
        action.focus-workspace-up = [ ];
      };

      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
      "Mod+Ctrl+U" = {
        hotkey-overlay.title = "Move to workspace down";
        action.move-column-to-workspace-down = [ ];
      };
      "Mod+Ctrl+I" = {
        hotkey-overlay.title = "Move to workspace up";
        action.move-column-to-workspace-up = [ ];
      };

      "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
      "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
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

      "Print" = {
        hotkey-overlay.title = "Screenshot";
        action.screenshot = [ ];
      };
      "Ctrl+Print" = {
        hotkey-overlay.title = "Screenshot screen";
        action.screenshot-screen = [ ];
      };
      "Alt+Print" = {
        hotkey-overlay.title = "Screenshot window";
        action.screenshot-window = [ ];
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
