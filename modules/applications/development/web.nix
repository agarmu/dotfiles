{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs
        pnpm
        typescript-language-server
        vscode-langservers-extracted
        prettierd
      ];
      programs.nixvim.plugins.lsp.servers = {
        ts_ls.enable = true;
        eslint.enable = true;
        html.enable = true;
        cssls.enable = true;
      };
      programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft = {
        javascript = [ "prettierd" ];
        javascriptreact = [ "prettierd" ];
        typescript = [ "prettierd" ];
        typescriptreact = [ "prettierd" ];
        css = [ "prettierd" ];
        html = [ "prettierd" ];
        json = [ "prettierd" ];
      };
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          css
          html
          javascript
          jsdoc
          tsx
          typescript
        ];
    };
}
