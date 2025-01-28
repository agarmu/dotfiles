{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
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
    historySubstringSearch.enable = true;
    envExtra = ''
      autoload -Uz compinit
      eval "$(/usr/libexec/path_helper)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/etc/profiles/per-user/mukul/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:"$PATH
      export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib"
      export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include"
      HISTSIZE=1000000000
      SAVEHIST=$HISTSIZE
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
      # Add Cargo, LLVM, and Brew Prefixes to path
      export PATH="$HOME/.cargo/bin:$(brew --prefix)/opt/llvm/bin:$(brew --prefix)/opt/libiconv/bin:$PATH"

      source /Users/mukul/.ghcup/env
      # set $TERM to wezterm...
      if [[ -v WEZTERM_EXECUTABLE ]]; then
        export TERM=wezterm
      fi

      # BEGIN opam configuration
      # This is useful if you're using opam as it adds:
      #   - the correct directories to the PATH
      #   - auto-completion for the opam binary
      # This section can be safely removed at any time if needed.
      [[ ! -r "$HOME/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
      # END opam configuration
    '';
  };
}
