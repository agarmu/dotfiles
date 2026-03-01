{ inputs, ... }:
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
      defaultEditor = true;
    };
  };

  # user-level nixvim
  flake.modules.homeManager.base = _: {
    stylix.targets = {
      neovim.enable = false;
      nixvim.enable = false;
    };
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      plugins.lsp.enable = true;
      plugins.lualine = {
        enable = true;
        settings.options.theme = "catppuccin";
      };
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "macchiato";
          transparent_background = true;
        };
      };
    };
  };
  flake.modules.homeManager.nixosGui = _: {
    programs.nixvim.plugins.smear-cursor.enable = true;
  };
}
