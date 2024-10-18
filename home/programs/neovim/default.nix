{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  plugins = pkgs.vimPlugins;
  builder = pkgs.vimUtils.buildVimPlugin;
  catppuccin = builder {
    name = "catppuccin";
    src = inputs.vim-catppuccin-plug;
  };
  typst-vim = builder {
    name = "typst.vim";
    src = inputs.vim-typst-plug;
  };
  typst-preview = builder {
    name = "typst-preview.nvim";
    src = inputs.vim-typst-preview-plug;
  };
  nvim-tree = builder {
    name = "nvim-tree";
    src = inputs.vim-tree-plug;
  };
  omnisharp = builder {
    name = "omnisharp";
    src = inputs.vim-omnisharp-plug;
  };
  coqtail = builder {
    name = "coqtail";
    src = inputs.vim-coqtail-plug;
  };
in {
  # Snippets!
  # xdg.configFile."nvim/UltiSnips".source = ./snippets;
  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPython3Packages = ps: [
      ps.sympy
    ];
    extraConfig = ''
      filetype plugin indent on
      set smartindent
      syntax enable
      setlocal spell
      set spelllang=en_us
      set number
      inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
      colorscheme catppuccin-mocha
      set textwidth=80
      set colorcolumn=+0
      set rtp^="/Users/mukul/.opam/default/share/ocp-indent/vim"

    '';
    extraLuaConfig = ''
       if vim.g.neovide then
           -- Put anything you want to happen only in Neovide here
           vim.o.guifont = "FiraCode Nerd Font Mono:h12"

           -- vim clipboard settings

       end
      -- disable netrw at the very start of your init.lua
       vim.g.loaded_netrw = 1
       vim.g.loaded_netrwPlugin = 1

       -- optionally enable 24-bit colour
       vim.opt.termguicolors = true
    '';
    coc = {
      enable = true;
      settings = {
        languageserver = {
          typst = {
            command = "tinymist";
            filetypes = ["typst" "typ"];
          };
          ocaml = {
            command = "opam";
            args = ["config" "exec" "--" "ocamllsp"];
            filetypes = ["ocaml" "reason"];
          };
        };
      };
    };
    plugins = with plugins; [
      {
        plugin = omnisharp;
      }
      {
        plugin = catppuccin;
        type = "lua";
        config = ''
          require("catppuccin").setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
              comments = {}, -- Change the style of comments
              conditionals = { "italic" },
              loops = { "italic" },
              functions = {},
              keywords = {},
              strings = {},
              variables = {},
              numbers = {},
              booleans = {},
              properties = {},
              types = { "bold" },
              operators = {},
            },
            color_overrides = {},
            custom_highlights = {},
            integrations = {
              gitsigns = true,
              treesitter = true,
              coc_nvim = true,
            },
          })
        '';
      }
      yankring
      vim-nix
      vim-localvimrc
      {
        plugin = nvim-tree;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup()
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        '';
      }
      {
        plugin = vimtex;
        config = ''
          let g:tex_flavor='xelatex'
          let g:vimtex_view_method='skim'
          let g:vimtex_format_enabled=1
          let g:vimtex_quickfix_mode=0
          set conceallevel=1
          let g:vimtex_syntax_conceal = {
                \ 'accents': 1,
                \ 'ligatures': 1,
                \ 'cites': 1,
                \ 'fancy': 1,
                \ 'spacing': 1,
                \ 'greek': 1,
                \ 'math_bounds': 0,
                \ 'math_delimiters': 1,
                \ 'math_fracs': 1,
                \ 'math_super_sub': 1,
                \ 'math_symbols': 1,
                \ 'sections': 0,
                \ 'styles': 1,
          \}
          let g:vimtex_syntax_conceal_cites = {
                \ 'type': 'brackets',
                \ 'icon': '📖',
                \ 'verbose': v:true,
          \}
        '';
      }
      deoplete-nvim
      vim-commentary
      fzf-vim
      vim-wakatime
      {
        plugin = ultisnips;
        config = ''
          let g:UltiSnipsExpandTrigger = '<tab>'
          let g:UltiSnipsJumpForwardTrigger = '<tab>'
          let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
        '';
      }
      vim-startuptime
      nvim-treesitter.withAllGrammars
      nvim-treesitter-parsers.typst
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup({
             current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
             current_line_blame_opts = {
               virt_text = true,
               virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
               delay = 500,
               ignore_whitespace = false,
             },
          })
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          require("bufferline").setup {
            highlights = require("catppuccin.groups.integrations.bufferline").get()
          }
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
                theme = "catppuccin"
            }
          }
        '';
      }
      {
        plugin = typst-vim;
        config = ''
        '';
      }
      {
        plugin = typst-preview;
        type = "lua";
        config = ''
          require('typst-preview').setup()
        '';
      }
      {
        plugin = mason-nvim;
        type = "lua";
        config = ''
          require('mason').setup()
        '';
      }
      mason-lspconfig-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require'lspconfig'.tinymist.setup{
          filetypes = { "typst", "typ" }
          }
        '';
      }
      {
        plugin = headlines-nvim;
        type = "lua";
        config = ''
          require("headlines").setup()
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        '';
      }
      coqtail
      zoxide-vim
    ];
  };
}
