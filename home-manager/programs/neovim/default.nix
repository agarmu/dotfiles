{ config, pkgs, lib, ... }:
{
    # Snippets!
    xdg.configFile."nvim/UltiSnips".source = ./snippets;
    programs.neovim = {
        enable = true;
        coc = { enable = true; };
        defaultEditor = true;
        extraPackages = with pkgs; [
            zathura
        ];
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
        plugins = with pkgs.vimPlugins; [
            yankring
            vim-nix
            {
                plugin = vimtex;
                config = ''
                let g:tex_flavor='xelatex'
                let g:vimtex_view_method='zathura'
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
                config = ''
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
                plugin = dracula-nvim;
                config = ''
                colorscheme dracula
                '';
            }
            deoplete-nvim
            {
                plugin = lualine-nvim;
                type = "lua";
                config = ''
                    require('lualine').setup {
                        options = {
                            theme = "dracula"
                        }
                    }
                    vim.cmd "set noshowmode"
                '';
            }
            /*{
                plugin = lightline-vim;
                config = ''
                set noshowmode
                let g:lightline = {
                    \ 'colorscheme': 'gruvbox',
                    \ 'active': {
                    \   'right': [ [ 'lineinfo' ],
                    \              [ 'percent' ],
                    \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
                    \ },
                    \ 'component': {
                    \   'charvaluehex': '0x%B'
                    \ },
                \ }
                '';
            }*/
            gruvbox
            nerdtree
            vim-commentary
            fzf-vim
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
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
    };
}