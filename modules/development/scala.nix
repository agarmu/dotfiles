{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers.metals = {
      enable = true;
      package = null;
    };
  };
}
