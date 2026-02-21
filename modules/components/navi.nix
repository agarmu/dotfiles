_: {
  flake.modules.homeManager.base = _: {
    programs.navi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
