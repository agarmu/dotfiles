{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers.hls = {
      enable = true;
      package = null;
      installGhc = false;
    };
  };
}
