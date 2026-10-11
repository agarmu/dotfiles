{
  flake.modules.homeManager.dev.programs.helix.settings = {
    theme = "catppuccin_latte";

    editor = {
      line-number = "absolute";
      cursorline = true;
      true-color = true;
      mouse = true;
      scrolloff = 8;
      idle-timeout = 250;
      completion-trigger-len = 1;
      completion-timeout = 5;
      auto-pairs = true;
      auto-format = true;
      bufferline = "multiple";
      color-modes = true;
      rulers = [ 80 ];
      lsp = {
        display-messages = true;
        display-progress-messages = true;
        display-inlay-hints = true;
      };
      gutters = [
        "diagnostics"
        "spacer"
        "line-numbers"
        "spacer"
        "diff"
      ];
      indent-guides = {
        render = true;
        character = "┊";
      };
      soft-wrap = {
        enable = true;
        wrap-at-text-width = true;
      };
    };
  };
}
