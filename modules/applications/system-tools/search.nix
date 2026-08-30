{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = false;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
    programs.fd.enable = true;
    programs.ripgrep.enable = true;
  };
}
