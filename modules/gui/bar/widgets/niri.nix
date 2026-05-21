{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
      programs.waybar.settings.mainBar = {
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
          hide-empty = true;
        };

        "niri/window" = {
          format = "{app_id}: {title}";
          rewrite = {
            "^firefox: (.+) — Mozilla Firefox$" = "🌎 $1";
            "^firefox: Mozilla Firefox$" = "🌎";
            "^com.mitchellh.ghostty: (.+)$ " = " $1";
            "^(neovide|dev.zed.Zed): (.*)$" = "󰅴 $2";
            "^vesktop: (.*)$" = "  $1";
            "^$" = "";
          };
        };
      };
    };
}
