{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers = {
      ts_ls = {
        enable = true;
        package = null;
      };
      astro = {
        enable = true;
        package = null;
      };
    };
  };
}
