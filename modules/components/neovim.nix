{ ... }:
let
  nvimConfig = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
in
{
  # always have neovim
  flake.modules.nixos.base = nvimConfig;
  flake.modules.homeManager.base = {
    inherit (nvimConfig) programs;
  };
}
