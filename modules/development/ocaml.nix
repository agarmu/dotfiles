_: {
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers.ocamllsp = {
      enable = true;
      package = null;
    };
  };
}
