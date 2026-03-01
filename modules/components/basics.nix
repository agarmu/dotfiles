_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.man = {
        enable = true;
        generateCaches = true;
      };
      programs.info.enable = true;
      programs.tealdeer = {
        enable = true;
        settings.updates.auto_update = true;
      };
      programs.navi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      home.packages = with pkgs; [
        killall
        bc
      ];
    };
}
