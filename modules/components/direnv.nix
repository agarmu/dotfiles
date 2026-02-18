_: {
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        #enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
}
