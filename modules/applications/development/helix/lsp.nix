{
  flake.modules.homeManager.dev.programs.nhx.languages = {
    language-server = {
      nixd = {
        command = "nixd";
      };
      clangd = {
        command = "clangd";
        args = [
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
        ];
      };
      rust-analyzer = {
        command = "rust-analyzer";
      };
      metals = {
        command = "metals";
      };
      hls = {
        command = "haskell-language-server-wrapper";
        args = [ "--lsp" ];
      };
      basedpyright = {
        command = "basedpyright-langserver";
        args = [ "--stdio" ];
      };
      ruff = {
        command = "ruff";
        args = [ "server" ];
      };
      ocamllsp = {
        command = "ocamllsp";
      };
      asm-lsp = {
        command = "asm-lsp";
      };
      texlab = {
        command = "texlab";
      };
      ltex = {
        command = "ltex-ls";
        config.ltex.disabledRules."en-US" = [ "MORFOLOGIK_RULE_EN_US" ];
      };
      tinymist = {
        command = "tinymist";
        args = [ "lsp" ];
      };
      marksman = {
        command = "marksman";
        args = [ "server" ];
      };
    };

    language = [
      {
        name = "nix";
        language-servers = [ "nixd" ];
        auto-format = true;
        formatter = {
          command = "nixfmt";
        };
      }
      {
        name = "c";
        language-servers = [ "clangd" ];
      }
      {
        name = "cpp";
        language-servers = [ "clangd" ];
      }
      {
        name = "rust";
        language-servers = [ "rust-analyzer" ];
      }
      {
        name = "scala";
        language-servers = [ "metals" ];
      }
      {
        name = "haskell";
        language-servers = [ "hls" ];
      }
      {
        name = "python";
        language-servers = [
          "basedpyright"
          "ruff"
        ];
      }
      {
        name = "ocaml";
        language-servers = [ "ocamllsp" ];
      }
      {
        name = "gas";
        language-servers = [ "asm-lsp" ];
      }
      {
        name = "nasm";
        language-servers = [ "asm-lsp" ];
      }
      {
        name = "latex";
        language-servers = [
          "texlab"
          "ltex"
        ];
      }
      {
        name = "typst";
        language-servers = [ "tinymist" ];
      }
      {
        name = "markdown";
        language-servers = [
          "marksman"
          "ltex"
        ];
      }
    ];
  };
}
