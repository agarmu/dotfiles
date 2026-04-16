{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers.asm_lsp.enable = true;
  };
}
