{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers.basedpyright = {
      enable = true;
      package = null;
    };
  };
}
