_: {
  flake.modules.homeManager.base = {
    programs.tmux = {
      enable = true;

      # Prefix: C-a instead of C-b
      shortcut = "a";

      mouse = true;
      keyMode = "vi";
      historyLimit = 10000;
      escapeTime = 0;
      clock24 = true;
      focusEvents = true;
      aggressiveResize = true;
      customPaneNavigationAndResize = true;
      sensibleOnTop = true;
      newSession = true;

      tmuxinator = {
        enable = true;
      };

      extraConfig = ''
        # Keybindings
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D
        unbind '"'
        unbind %

        # Behavior
        set -g allow-rename off
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        set -g monitor-activity off
        set -g bell-action none

        # Appearance
        set -g clock-mode-colour yellow
        set -g mode-style 'fg=black bg=yellow bold'
        set -g pane-border-style 'fg=brightblack'
        set -g pane-active-border-style 'fg=cyan'
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'fg=cyan'
        set -g status-left ""
        set -g status-right-style 'fg=black bg=cyan'
        set -g status-right ' %Y-%m-%d %H:%M '
        set -g window-status-current-style 'fg=black bg=cyan bold'
        set -g window-status-current-format ' #I #W #F '
        set -g window-status-style 'fg=cyan bg=black'
        set -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '
        set -g window-status-bell-style 'fg=yellow bg=red bold'
        set -g message-style 'fg=yellow bg=black bold'
      '';
    };
  };
}
