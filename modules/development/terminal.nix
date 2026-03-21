_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        settings = {
          window_border_width = "0px";
          tab_bar_edge = "top";
          tab_bar_margin_width = "0.0";
          tab_bar_style = "fade";
          placement_strategy = "top-left";
          hide_window_decorations = true;
          cursor_trail = "1";
        };
      };
    };
}
