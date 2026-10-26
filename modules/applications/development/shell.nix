_: {
  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.file.".hushlogin".text = "";

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
          set --global pure_enable_single_line_prompt true
          set --global pure_threshold_command_duration 2
          set --global pure_enable_nixdevshell true
          set --global pure_symbol_nixdevshell_prefix " "
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
            # native Fish prompt with synchronous Git status
            pure
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
    };

}
