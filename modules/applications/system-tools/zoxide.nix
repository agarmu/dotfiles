{
  flake.modules.homeManager.base = {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
