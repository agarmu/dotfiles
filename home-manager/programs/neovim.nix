{ config, pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        coc = { enable = true; };
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; [
            yankring
            vim-nix
            lightline-vim
            dracula-nvim
            nerdtree
            vim-commentary
            fzf-vim
            vim-startuptime
            {
                plugin = dashboard-nvim;
            }
        ];
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
    };
}