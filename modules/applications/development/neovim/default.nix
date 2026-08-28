{ lib, inputs, ... }:
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

  # gui
  flake.modules.homeManager.gui = {
    programs.neovide.enable = true;
  };
  flake.modules.homeManager.linuxGui = {
    xdg.mimeApps.defaultApplications = {
      "text/plain" = [ "neovide.desktop" ];
      "text/english" = [ "neovide.desktop" ];
      "application/x-desktop" = [ "neovide.desktop" ];
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
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];
      programs.nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;

        nixpkgs.source = inputs.nixpkgs;

        globals = {
          mapleader = " ";
          maplocalleader = "\\";

          # stylix doesn't target neovide; apply window opacity ourselves
          neovide_opacity = config.stylix.opacity.terminal;
        };

        opts = {
          background = "light";
          number = true; # absolute line numbers
          signcolumn = "yes"; # always show, avoids layout shift
          cursorline = true; # highlight current line
          scrolloff = 8; # keep context above/below cursor
          sidescrolloff = 8;
          termguicolors = true; # 24-bit color
          undofile = true; # persistent undo across sessions
          confirm = true; # ask before discarding unsaved changes
          mouse = "a";
          updatetime = 250; # faster diagnostics and git signs
          timeoutlen = 300; # responsive which-key popups
          completeopt = [
            "menu"
            "menuone"
            "noselect"
          ];
          inccommand = "split"; # preview substitutions live
          list = true;
          listchars = {
            tab = "» ";
            trail = "·";
            nbsp = "␣";
          };
          wrap = false;
          # case-insensitive search unless query has uppercase
          ignorecase = true;
          smartcase = true;
          splitright = true; # open vertical splits to the right
          splitbelow = true; # open horizontal splits below
          foldlevelstart = 99; # create folds but leave them open initially
        };

        keymaps = [
          # General editing and navigation.
          {
            mode = "n";
            key = "<Esc>";
            action = "<cmd>nohlsearch<cr>";
            options.desc = "Clear search highlight";
          }
          {
            mode = "n";
            key = "<leader>w";
            action = "<cmd>write<cr>";
            options.desc = "Save file";
          }
          {
            mode = "n";
            key = "<leader>qq";
            action = "<cmd>quitall<cr>";
            options.desc = "Quit Neovim";
          }
          {
            mode = "x";
            key = "<";
            action = "<gv";
            options.desc = "Indent left";
          }
          {
            mode = "x";
            key = ">";
            action = ">gv";
            options.desc = "Indent right";
          }

          # Windows and buffers.
          {
            mode = "n";
            key = "<C-h>";
            action = "<C-w>h";
            options.desc = "Focus left window";
          }
          {
            mode = "n";
            key = "<C-j>";
            action = "<C-w>j";
            options.desc = "Focus lower window";
          }
          {
            mode = "n";
            key = "<C-k>";
            action = "<C-w>k";
            options.desc = "Focus upper window";
          }
          {
            mode = "n";
            key = "<C-l>";
            action = "<C-w>l";
            options.desc = "Focus right window";
          }
          {
            mode = "n";
            key = "<leader>-";
            action = "<cmd>split<cr>";
            options.desc = "Split below";
          }
          {
            mode = "n";
            key = "<leader>|";
            action = "<cmd>vsplit<cr>";
            options.desc = "Split right";
          }
          {
            mode = "n";
            key = "<S-h>";
            action = "<cmd>bprevious<cr>";
            options.desc = "Previous buffer";
          }
          {
            mode = "n";
            key = "<S-l>";
            action = "<cmd>bnext<cr>";
            options.desc = "Next buffer";
          }
          {
            mode = "n";
            key = "<leader>bd";
            action = "<cmd>lua require('mini.bufremove').delete(0, false)<cr>";
            options.desc = "Delete buffer";
          }

          # Project navigation and search.
          {
            mode = "n";
            key = "<leader><space>";
            action = "<cmd>Telescope find_files<cr>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>/";
            action = "<cmd>Telescope live_grep<cr>";
            options.desc = "Search project text";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<cr>";
            options.desc = "Find buffers";
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<cr>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope git_files<cr>";
            options.desc = "Find Git files";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Telescope help_tags<cr>";
            options.desc = "Search help";
          }
          {
            mode = "n";
            key = "<leader>fr";
            action = "<cmd>Telescope oldfiles<cr>";
            options.desc = "Recent files";
          }
          {
            mode = "n";
            key = "<leader>e";
            action = "<cmd>Neotree toggle reveal<cr>";
            options.desc = "Toggle file explorer";
          }

          # Diagnostics and lists.
          {
            mode = "n";
            key = "]d";
            action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<cr>";
            options.desc = "Next diagnostic";
          }
          {
            mode = "n";
            key = "[d";
            action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<cr>";
            options.desc = "Previous diagnostic";
          }
          {
            mode = "n";
            key = "<leader>cd";
            action = "<cmd>lua vim.diagnostic.open_float()<cr>";
            options.desc = "Line diagnostics";
          }
          {
            mode = "n";
            key = "<leader>xx";
            action = "<cmd>Trouble diagnostics toggle<cr>";
            options.desc = "Workspace diagnostics";
          }
          {
            mode = "n";
            key = "<leader>xX";
            action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
            options.desc = "Buffer diagnostics";
          }
          {
            mode = "n";
            key = "<leader>xq";
            action = "<cmd>Trouble qflist toggle<cr>";
            options.desc = "Quickfix list";
          }
          {
            mode = "n";
            key = "]q";
            action = "<cmd>cnext<cr>";
            options.desc = "Next quickfix item";
          }
          {
            mode = "n";
            key = "[q";
            action = "<cmd>cprevious<cr>";
            options.desc = "Previous quickfix item";
          }

          # Git.
          {
            mode = "n";
            key = "]h";
            action = "<cmd>Gitsigns nav_hunk next<cr>";
            options.desc = "Next Git hunk";
          }
          {
            mode = "n";
            key = "[h";
            action = "<cmd>Gitsigns nav_hunk prev<cr>";
            options.desc = "Previous Git hunk";
          }
          {
            mode = "n";
            key = "<leader>gb";
            action = "<cmd>Gitsigns blame_line<cr>";
            options.desc = "Blame line";
          }
          {
            mode = "n";
            key = "<leader>gd";
            action = "<cmd>Gitsigns diffthis<cr>";
            options.desc = "Diff against index";
          }
          {
            mode = "n";
            key = "<leader>gp";
            action = "<cmd>Gitsigns preview_hunk<cr>";
            options.desc = "Preview hunk";
          }
          {
            mode = "n";
            key = "<leader>gs";
            action = "<cmd>Telescope git_status<cr>";
            options.desc = "Git status";
          }

          # Formatting.
          {
            mode = [
              "n"
              "x"
            ];
            key = "<leader>cf";
            action = "<cmd>lua if vim.bo.filetype ~= 'tex' and vim.bo.filetype ~= 'plaintex' then require('conform').format({ async = true, lsp_format = 'fallback' }) end<cr>";
            options.desc = "Format buffer or selection";
          }
        ];

        autoCmd = [
          {
            event = "TextYankPost";
            pattern = "*";
            command = "silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })";
          }
        ];

        colorschemes.catppuccin = {
          enable = true;
          settings = {
            flavour = "latte";
            term_colors = true;

            integrations = {
              cmp = true;
              gitsigns = true;
              treesitter = true;
              telescope.enabled = true;
              native_lsp.enabled = true;
            };
            # transparent in terminal, opaque in neovide (GUI bg handled by neovide)
            transparent_background.__raw = "(vim.g.neovide and 0) or 1";
          };
        };

        plugins = {
          lsp.enable = true; # language server protocol
          lualine = {
            enable = true; # statusline
            settings.options.globalstatus = true;
          };
          neo-tree = {
            enable = true; # sidebar file browser
            settings = {
              close_if_last_window = true;
              filesystem = {
                follow_current_file.enabled = true;
                use_libuv_file_watcher = true;
              };
              window.width = 34;
            };
          };
          telescope = {
            enable = true; # fuzzy finder
            extensions.fzf-native.enable = true;
            settings.defaults = {
              path_display = [ "smart" ];
              sorting_strategy = "ascending";
              layout_config.prompt_position = "top";
            };
          };
          treesitter = {
            enable = true; # syntax highlighting
            grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              lua
              regex
              vim
              vimdoc
            ];
            settings = {
              highlight.enable = true;
              indent.enable = true;
            };
          };
          blink-cmp = {
            enable = true; # autocompletion
            settings = {
              keymap = {
                preset = "default";
                "<CR>" = [
                  "accept"
                  "fallback"
                ];
                "<Tab>" = [
                  "snippet_forward"
                  "accept"
                  "fallback"
                ];
                "<S-Tab>" = [
                  "snippet_backward"
                  "fallback"
                ];
              };
              completion = {
                documentation.auto_show = true;
                ghost_text.enabled = true;
              };
              signature.enabled = true;
            };
          };
          gitsigns.enable = true; # git gutters
          which-key = {
            enable = true; # keybinding hints
            settings.delay = 300;
          };
          indent-blankline.enable = true; # indentation guides
          nvim-autopairs.enable = true; # auto-close brackets
          trouble.enable = true; # diagnostics panel
          conform-nvim = {
            enable = true;
            settings = {
              format_on_save = ''
                function(bufnr)
                  local filetype = vim.bo[bufnr].filetype
                  if filetype == "tex" or filetype == "plaintex" then
                    return
                  end
                  return { timeout_ms = 1000, lsp_format = "fallback" }
                end
              '';
              notify_on_error = true;
              notify_no_formatters = false;
            };
          };
          fidget.enable = true; # unobtrusive LSP progress
          todo-comments.enable = true; # highlight TODO/FIXME annotations
          smear-cursor.enable = true;
          mini = {
            enable = true;
            modules = {
              ai = { }; # richer text objects
              bufremove = { }; # close buffers without destroying layouts
              comment = { };
              icons = { };
              splitjoin = { };
              surround = { };
              trailspace = { };
            };
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
