{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
    programs.fd.enable = true;
    programs.ripgrep.enable = true;
  };
}
