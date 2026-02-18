{ ... }:
{
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      programs.fd.enable = true;
      programs.ripgrep.enable = true;
    };
}
