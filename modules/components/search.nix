{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      catppuccin.fzf.enable = true;
      programs.fd.enable = true;
      programs.ripgrep.enable = true;
    };
}
