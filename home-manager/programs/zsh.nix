{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    autocd = true;
    history = {
      ignoreDups = true;
      extended = true;
      ignorePatterns = [
        "ls *"
        "exa *"
        "pkill *"
      ];
    };
    historySubstringSearch.enable = true;
    envExtra = ''
      autoload -Uz compinit
      eval "$(/usr/libexec/path_helper)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/Users/mukul/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:"$PATH
      export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib"
      export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include"
      export HISTSIZE=1000000000
      export SAVEHIST=$HISTSIZE
      setopt EXTENDED_HISTORY
      eval "$(fnm env --use-on-cd)"

      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
              . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
          else
              export PATH="/opt/homebrew/anaconda3/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<
      export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
    '';
  };
}
