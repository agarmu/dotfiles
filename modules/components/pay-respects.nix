{
  flake.modules.homeManager.base = {
    programs.pay-respects = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
