_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
}
