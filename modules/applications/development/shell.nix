_: {
  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          fish
          zsh
        ];
      programs.mcfly = {
        enable = false;
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
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
      programs.fish = {
        enable = true;
        # disable fish greeting
        interactiveShellInit = ''
          set --global fish_greeting
          set --global fish_prompt_pwd_dir_length 2
          set --global hydro_cmd_duration_threshold 2000
          if set --query IN_NIX_SHELL
            set --global hydro_symbol_start " "
          end
          set --global sponge_purge_only_on_exit true
          set --global sponge_successful_exit_codes 0 130 141
        '';
        plugins =
          with pkgs.fishPlugins;
          [
            fzf-fish
            # notify when long-running commands finish
            done
            # keep failed commands and typos out of shell history
            sponge
            # expand navigation shortcuts and history substitutions
            puffer
            # pretty prompt
            hydro
          ]
          |> map (x: {
            inherit (x) src;
            name = x.pname;
          });
      };
      programs.bash = {
        enable = true;
        enableCompletion = true;
      };
      programs.starship = {
        enable = false;
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
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
