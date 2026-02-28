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
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      plugins.lsp.enable = true;
      plugins.lualine = {
        enable = true;
      };
    };
  };

  # neovide in the gui
  flake.modules.homeManager.gui = _: {
    programs.neovide = {
      enable = true;
    };
  };
}
