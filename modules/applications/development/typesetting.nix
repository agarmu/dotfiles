{
  flake.modules.homeManager.base = {
    programs.pandoc.enable = true;
  };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      texlivePackage = pkgs.texliveFull;
    in
    {
      programs.nixvim.plugins.vimtex = {
        enable = true;
        inherit texlivePackage;
        settings = {
          # latexmk handles the required reruns for references and bibliographies
          # and keeps the PDF current while writing.
          compiler_method = "latexmk";
          compiler_latexmk = {
            continuous = 1;
            callback = 1;
            options = [
              "-verbose"
              "-file-line-error"
              "-synctex=1"
              "-interaction=nonstopmode"
            ];
          };

          # Skim integrates with VimTeX's forward and inverse SyncTeX search.
          view_method = "skim";

          # Show the quickfix list for real compiler errors, without interrupting
          # the writing flow for routine LaTeX warnings.
          quickfix_mode = 1;

          fold_enabled = 1;
          toc_config = {
            split_pos = "vert rightbelow";
            split_width = 35;
            show_help = 0;
          };
        };
      };
      programs.nixvim.autoCmd = [
        {
          event = "FileType";
          pattern = [
            "tex"
            "plaintex"
          ];
          command = "setlocal spell spelllang=en_us wrap linebreak breakindent conceallevel=2 concealcursor=nc";
        }
      ];
      programs.nixvim.plugins.luasnip = {
        enable = true;
        filetypeExtend.plaintex = [ "tex" ];
      };
      programs.nixvim.plugins.blink-cmp.settings.sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
      programs.nixvim.extraConfigLua = builtins.readFile ./neovim/latex-snippets.lua;
      programs.nixvim.plugins.lsp.servers = {
        texlab.enable = true;
        ltex.enable = true;
        tinymist.enable = true;
        marksman.enable = true;
      };
      programs.zed-editor.extensions = [
        "latex"
        "typst"
      ];
      home.packages = with pkgs; [
        texlivePackage
        texlab # LaTeX LSP
        tinymist # Typst LSP
        marksman # Markdown LSP
        ltex-ls # grammar/spell checking LSP (LanguageTool)
        tex-fmt # LaTeX formatter
        tectonic # self-contained LaTeX engine
        vale # prose linter (style guide enforcement)
        typst # modern typesetting
        bibtool # manipulate BibTeX
      ];
    };
}
