{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          c
          cpp
        ];
      programs.nixvim.plugins.lsp.servers.clangd = {
        enable = true;
        packageFallback = true;
        cmd = [
          "clangd"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
        ];
      };
      programs.zed-editor.extensions = [ "c" ];
      home.packages = with pkgs; [
        gcc
        llvm
        clang-analyzer
        lldb
      ];
    };
}
