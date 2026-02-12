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
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        autocd = true;
        history = {
          ignoreDups = true;
          extended = true;
          size = 1000000000;
          ignorePatterns = [
            "ls *"
            "eza *"
            "pkill *"
          ];
        };
      };
      catppuccin.zsh-syntax-highlighting.enable = true;

      programs.bash = {
        enable = true;
        enableCompletion = true;
      };

      catppuccin.starship.enable = true;
      programs.starship = {
        enable = true;
      };
    };

}
