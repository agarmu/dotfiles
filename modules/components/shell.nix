{
  flake.modules.homeManager.base =
    {
      config,
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        enableCompletion = true;
      };

      programs.bash = {
        enable = true;
        enableCompletion = true;
      };

      programs.starship = {
        enable = true;
      };
    };

}
