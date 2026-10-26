{
  flake.modules.homeManager.base = { pkgs, ... }: {
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
      # Avoid tmux-sensible's synchronous shell script at server startup.
      # The useful defaults it supplied are set natively below instead.
      sensibleOnTop = false;
      newSession = true;

      tmuxinator = {
        enable = true;
      };

      plugins = [
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15'
          '';
        }
      ];

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
        set -g display-time 4000
        set -g status-interval 5
        set -g default-terminal screen-256color

        # Useful tmux-sensible bindings, without running the plugin.
        bind a last-window
        bind C-p previous-window
        bind C-n next-window

        # Appearance is supplied by the Catppuccin Mocha plugin.
        set -g status-position bottom
        set -g status-justify left
      '';
    };
  };
}
