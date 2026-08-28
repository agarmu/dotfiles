{
  flake.modules.homeManager.dev =
    { config, ... }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [ asm ];
      programs.nixvim.plugins.lsp.servers.asm_lsp.enable = true;
      programs.zed-editor.extensions = [ "assembly" ];
    };
}
