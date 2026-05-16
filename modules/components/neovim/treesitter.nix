{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.nixvim.treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          asm
          awk
          bash
          bibtex
          c
          cmake
          cpp
          diff
          haskell
          html
          http
          javascript
          just
          kdl
          kitty
          latex
          make
          markdown
          markdown_inline
          nix
          rust
          scala
          tsx
          zig
        ];
      };
    };
}
