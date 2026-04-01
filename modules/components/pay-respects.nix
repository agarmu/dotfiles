_: {
  flake.modules.homeManager.base = _: {
    programs.pay-respects = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
