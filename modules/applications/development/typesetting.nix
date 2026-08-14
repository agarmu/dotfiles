{
  flake.modules.homeManager.base = {
    programs.pandoc.enable = true;
  };
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    let
      texlivePackage = pkgs.texliveFull;
    in
    {
      programs.nixvim.plugins.vimtex = {
        enable = true;
        inherit texlivePackage;
        settings = {
          # LuaSnip and Blink provide the snippet and completion layers.
          imaps_enabled = false;
          complete_enabled = false;
          syntax_conceal_disable = true;

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

          # Use each platform's reliable SyncTeX-capable viewer.
          view_method = if pkgs.stdenv.hostPlatform.isDarwin then "skim" else "zathura";
          view_automatic = true;

          # Show the quickfix list for real compiler errors, without interrupting
          # the writing flow for routine LaTeX warnings.
          quickfix_open_on_warning = 0;
          quickfix_mode = 2;
          quickfix_autoclose_after_keystrokes = 1;

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
          command = "setlocal spell spelllang=en_us wrap linebreak breakindent";
        }
        {
          event = "FileType";
          pattern = [
            "markdown"
            "typst"
          ];
          command = "setlocal spell spelllang=en_us wrap linebreak breakindent";
        }
        {
          # Let VimTeX resolve the document entrypoint, then start latexmk's
          # continuous compiler.
          event = "User";
          pattern = "VimtexEventInitPost";
          command = "VimtexCompile";
        }
      ];
      programs.nixvim.plugins.luasnip = {
        enable = true;
        filetypeExtend.plaintex = [ "tex" ];
      };
      programs.nixvim.plugins.lint = {
        enable = true;
        lintersByFt = {
          markdown = [ "vale" ];
          plaintex = [ "vale" ];
          tex = [ "vale" ];
          typst = [ "vale" ];
        };
      };
      programs.nixvim.plugins.blink-cmp.settings.sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
      programs.nixvim.globals.tex_flavor = "latex";
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
      xdg.configFile = {
        "vale/.vale.ini".text = ''
          StylesPath = ${config.xdg.configHome}/vale/styles
          MinAlertLevel = warning

          [*.{md,tex,typ}]
          BasedOnStyles = Vale
        '';
        "vale/styles/.keep".text = "";
      };
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
