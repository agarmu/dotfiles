{ lib, ... }:
{
  flake.modules.homeManager.linuxGui =
    { config, ... }:
    {
      stylix.targets.waybar.enable = false;

      programs.waybar.style =
        let
          inherit (config.lib.stylix) colors;
          bases = map lib.toHexString (lib.range 0 15);

          # 2. Map through them to create the @define-color rules
          definitions = lib.concatMapStringsSep "\n" (
            base: "@define-color base0${base} #${colors."base0${base}"};"
          ) bases;
          font = ''
            * {
              font-family: monospace;
              font-size: ${(toString config.stylix.fonts.sizes.desktop)}px;
            }
          '';
        in
        ''
          /* COLOR DEFINITIONS */
          ${definitions}

          /* FONT DEFINITIONS */
          ${font}

          ${builtins.readFile ./bar.css}
        '';

    };
}
