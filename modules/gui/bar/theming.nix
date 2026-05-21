_: {
  flake.modules.homeManager.nixosGui =
    { config, ... }:
    {
      stylix.targets.waybar.enable = false;

      programs.waybar.style =
        let
          inherit (config.lib.stylix) colors;
        in
        builtins.replaceStrings
          [
            "~fontFamily~"
            "~fontSize~"
            "~base00~"
            "~base07~"
            "~base08~"
            "~base0A~"
            "~base0B~"
          ]
          [
            "monospace"
            "${(toString config.stylix.fonts.sizes.desktop)}px"
            colors.base00
            colors.base07
            colors.base08
            colors.base0A
            colors.base0B
          ]
          (builtins.readFile ./bar.css);
    };
}
