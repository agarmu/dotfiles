_: {
  flake.modules.homeManager.base =
    {
      config,
      ...
    }:
    {
      programs.mcfly = {
        enable = false;
        enableZshIntegration = true;
        enableBashIntegration = true;
        fzf.enable = true;
        interfaceView = "BOTTOM";
      };
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        defaultKeymap = "emacs";
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        autocd = true;
        history = {
          ignoreDups = true;
          extended = true;
          size = 1000000;
          ignorePatterns = [
            "ls *"
            "eza *"
            "pkill *"
          ];
        };
      };
      programs.bash = {
        enable = true;
        enableCompletion = true;
      };
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[>](bold green)";
            error_symbol = "[x](bold red)";
          };
          directory = {
            truncation_length = 3;
            truncate_to_repo = true;
            style = "bold cyan";
          };
          cmd_duration.min_time = 2000;
        };
      };
    };

}
