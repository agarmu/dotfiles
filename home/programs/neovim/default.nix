{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  catppuccin = pkgs.vimUtils.buildVimPlugin {
    name = "catppuccin";
    src = inputs.vim-catppuccin-plug;
  };
  typst-vim = pkgs.vimUtils.buildVimPlugin {
    name = "typst.vim";
    src = inputs.vim-typst-plug;
  };
  nvim-tree = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-tree";
    src = inputs.vim-tree-plug;
  };

  plugins = pkgs.vimPlugins;
in {
  # Snippets!
  xdg.configFile."nvim/UltiSnips".source = ./snippets;
  programs.neovim = {
    enable = true;
    extraPython3Packages = ps: [
      ps.sympy
    ];
    extraConfig = ''
      filetype plugin indent on
      syntax enable
      setlocal spell
      set spelllang=en_us
      set number
      inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
      colorscheme catppuccin
    '';
    extraLuaConfig = ''
    '';
    plugins = with plugins; [
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
      nvim-tree
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
      nerdtree
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
      {
        plugin = neorg;
        type = "lua";
        config = ''
            require('neorg').setup {
              load = {
                  ["core.defaults"] = {},
                  ["core.concealer"] = {},
                  ["core.dirman"] = {
                      config = {
                          workspaces = {
                              main = "~/notes",
                          }
                      }
                  }
              }
          }
        '';
      }
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
      typst-vim
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
          require'lspconfig'.typst_lsp.setup{
            settings = {
              exportPdf = "onType" -- Choose onType, onSave or never.
              -- serverPath = "" -- Normally, there is no need to uncomment it.
            },
            filetypes = { "typst", "typ" }
          }
        '';
      }
    ];
    coc = {
      enable = true;
      settings = {
        languageserver = {
          typst = {
            command = "typst-lsp";
            filetypes = ["typst" "typ"];
          };
        };
      };
    };
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
