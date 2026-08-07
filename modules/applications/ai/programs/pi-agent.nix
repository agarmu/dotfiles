{
  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      programs.pi-coding-agent = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "pi-coding-agent";
          buildInputs = [ pkgs.makeWrapper ];
          paths = [ pkgs.pi-coding-agent ];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --set NPM_CONFIG_PREFIX "\$XDG_CONFIG_HOME/npm/" \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.nodejs_latest
                ]
              }
          '';
        };
        configDir = "${config.xdg.configHome}/pi/agent";
        settings = {
          autoshare = false;
          autoupdate = false;
        };
      };
    };
}
