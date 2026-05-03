{ lib, ... }:
{
  flake-file.inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # system-level neovim for root/recovery
  flake.modules.nixos.base = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = lib.mkDefault true;
    };
  };

  # user-level nixvim
  flake.modules.homeManager.base =
    { config, ... }:
    {
      stylix.targets = {
        neovim.enable = false;
        nixvim.enable = false;
      };
      programs.neovide.enable = true;
      programs.nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;

        # stylix doesn't target neovide; apply window opacity ourselves
        globals.neovide_opacity = config.stylix.opacity.terminal;

        opts = {
          number = true; # absolute line numbers
          signcolumn = "yes"; # always show, avoids layout shift
          cursorline = true; # highlight current line
          scrolloff = 8; # keep context above/below cursor
          termguicolors = true; # 24-bit color
          undofile = true; # persistent undo across sessions
          # case-insensitive search unless query has uppercase
          ignorecase = true;
          smartcase = true;
          splitright = true; # open vertical splits to the right
          splitbelow = true; # open horizontal splits below
        };

        colorschemes.everforest = {
          enable = true;
          settings = {
            background = "hard";
            # transparent in terminal, opaque in neovide (GUI bg handled by neovide)
            transparent_background.__raw = "(vim.g.neovide and 0) or 1";
          };
        };

        plugins = {
          lsp.enable = true; # language server protocol
          lualine.enable = true; # statusline
          neo-tree.enable = true; # sidebar file browser
          telescope.enable = true; # fuzzy finder
          treesitter.enable = true; # syntax highlighting
          blink-cmp.enable = true; # autocompletion
          gitsigns.enable = true; # git gutters
          which-key.enable = true; # keybinding hints
          indent-blankline.enable = true; # indentation guides
          nvim-autopairs.enable = true; # auto-close brackets
          trouble.enable = true; # diagnostics panel
          mini = {
            enable = true;
            modules.icons = { };
            mockDevIcons = true;
          };
        };

        performance = {
          byteCompileLua = {
            enable = true;
            configs = true;
          };
        };

      };
    };
}
