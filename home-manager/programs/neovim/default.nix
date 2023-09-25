{
  config,
  pkgs,
  lib,
  ...
}: let
  plugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix {};
in {
  # Snippets!
  xdg.configFile."nvim/UltiSnips".source = ./snippets;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPython3Packages = ps: [
      ps.sympy
    ];
    extraConfig = ''

      filetype plugin indent on
      syntax enable
      setlocal spell
      set spelllang=en_us
      inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

    '';
    extraLuaConfig = ''
    '';
    plugins = with plugins; [
      yankring
      vim-nix
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
      {
        plugin = gruvbox;
        config = ''          :
                    let g:gruvbox_bold=1
                    let g:gruvbox_italic=1
                    let g:gruvbox_transparent_bg=1
                    let g:gruvbox_underline=1
                    let g:gruvbox_undercurl=1
                    let g:gruvbox_termcolors=1
                    set background=dark
        '';
      }
      {
        plugin = catppuccin;
        config = ''
          colorscheme catppuccin-macchiato 
        '';
      }
      deoplete-nvim
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
          	options = {
          		theme = "solarized_light"
          	}
          }
          vim.cmd "set noshowmode"
        '';
      }
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
