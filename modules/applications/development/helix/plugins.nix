{
  flake.modules.homeManager.dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) helix-plugins;
      pluginPackages = [
        helix-plugins.glyph
        helix-plugins.forest
        helix-plugins.oil
        helix-plugins.scooter
        helix-plugins.smooth-scroll
        helix-plugins.streal
        helix-plugins.wakatime
        helix-plugins.file-watcher
      ];
      nativePluginPackages = builtins.filter (plugin: (plugin.native or null) != null) pluginPackages;
      pluginLoadCheck =
        pkgs.runCommand "nhx-steel-plugin-load-check"
          {
            nativeBuildInputs = [
              config.programs.nhx.package
              pkgs.coreutils
              pkgs.expect
            ];
          }
          ''
            set -eu
            export HOME="$TMPDIR/home"
            export XDG_CONFIG_HOME="$TMPDIR/config"
            export STEEL_HOME="$HOME/.local/share/steel"
            helix_config="$XDG_CONFIG_HOME/helix"
            mkdir -p "$STEEL_HOME/cogs" "$STEEL_HOME/native" "$helix_config"
            ${lib.concatMapStringsSep "\n" (plugin: ''
              ln -s ${plugin} "$STEEL_HOME/cogs/${plugin.cogName}"
            '') pluginPackages}
            ${lib.concatMapStringsSep "\n" (plugin: ''
              ln -s ${plugin.native}/* "$STEEL_HOME/native/"
            '') nativePluginPackages}
            cat ${
              builtins.toFile "nhx-init.scm" config.home.file.".config/helix/init.scm".text
            } > "$helix_config/init.scm"
            printf '%s\n' \
              ';; Proxy user config for the plugin load check.' \
              > "$helix_config/helix.scm"
            touch "$helix_config/config.toml"
            export HELIX_CONFIG="$helix_config/config.toml"
            export HELIX_LOG="$TMPDIR/hx.log"
            expect -c 'set timeout 5; log_user 1; spawn hx --config $env(HELIX_CONFIG) --log $env(HELIX_LOG); expect eof' \
              </dev/null || true
            if grep -Eiq '(error|failed|panic)' "$TMPDIR/hx.log"; then
              cat "$TMPDIR/hx.log" >&2
              exit 1
            fi
            mkdir -p "$out"
          '';
    in
    {
      home.packages = [ pluginLoadCheck ];

      programs.nhx = {
        steel = {
          enable = true;
          lsp.enable = false;
        };

        # Keep Helix's native keymap. These plugins cover the surrounding UI
        # provided by neo-tree, lualine, Telescope, and Trouble in Neovim.
        plugins = {
          forest.package = helix-plugins.forest;
          oil = {
            enable = true;
            package = helix-plugins.oil;
          };
          scooter = {
            enable = true;
            package = helix-plugins.scooter;
          };
          smooth-scroll = {
            enable = true;
            package = helix-plugins.smooth-scroll;
          };
          streal = {
            enable = true;
            package = helix-plugins.streal;
          };
          wakatime = {
            enable = true;
            package = helix-plugins.wakatime;
          };
          helix-file-watcher = {
            enable = true;
            package = helix-plugins.file-watcher;
            requirePath = "helix-file-watcher/file-watcher.scm";
            extra = "(spawn-watcher)";
          };
        };
      };
    };
}
