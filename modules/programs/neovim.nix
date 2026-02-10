{ ... }:
{
  # TODO: switch to nixvim
  flake.modules.nixos.base = {
    programs.firefox.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
