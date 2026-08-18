{
  flake.modules.homeManager.dev.programs.nhx.settings = {
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

    keys.normal = {
      C-d = ":half-page-down-smooth";
      C-u = ":half-page-up-smooth";
      pageup = ":page-up-smooth";
      pagedown = ":page-down-smooth";
      "\\" = ":streal-open --per-branch";
      space = {
        o = ":oil";
        t = ":open-term";
      };
    };

    keys.select."\\" = ":streal-open --per-branch";
  };
}
