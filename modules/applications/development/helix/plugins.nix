{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      localPlugins = pkgs.callPackage ../../../../pkgs/helix-plugins { };
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
          forest.package = localPlugins.forest;
          moka.package = localPlugins.moka;
          oil = {
            enable = true;
            package = localPlugins.oil;
          };
          scooter = {
            enable = true;
            package = localPlugins.scooter;
          };
          smooth-scroll = {
            enable = true;
            package = localPlugins.smooth-scroll;
          };
          streal = {
            enable = true;
            package = localPlugins.streal;
          };
          wakatime = {
            enable = true;
            package = localPlugins.wakatime;
          };
          helix-file-watcher = {
            enable = true;
            package = localPlugins.file-watcher;
            requirePath = "helix-file-watcher/file-watcher.scm";
            extra = "(spawn-watcher)";
          };
        };
      };
    };
}
