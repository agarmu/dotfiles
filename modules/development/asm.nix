_: {
  flake.modules.homeManager.dev = _: {
    programs.nixvim.plugins.lsp.servers.asm_lsp.enable = true;
  };
}
