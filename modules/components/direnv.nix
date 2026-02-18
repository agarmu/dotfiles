_: {
  flake.modules.homeManager.base = _: {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      #enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
