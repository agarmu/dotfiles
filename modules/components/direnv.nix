_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        #enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
}
