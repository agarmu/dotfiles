{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      inherit (pkgs) helix-plugins;
    in
    {
      xdg.configFile."helix/helix.scm".text = ''
        ;; User-defined Steel commands. Managed by Home Manager.
      '';

      programs.nhx = {
        steel = {
          enable = true;
          lsp.enable = false;
        };

        # Keep Helix's native keymap. These plugins cover the surrounding UI
        # provided by neo-tree, lualine, Telescope, and Trouble in Neovim.
        plugins = {
          forest.package = helix-plugins.forest;
          moka-bufferline = {
            enable = true;
            package = helix-plugins.moka;
            requirePath = "moka/moka.scm";
            extra = ''
              (moka-bufferline-configure! #:gap 0)
              (moka-bufferline-enable!)
            '';
          };
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
