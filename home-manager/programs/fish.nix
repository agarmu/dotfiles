{ config, pkgs, ... }:
{
	programs.fish = {
          enable = false;

          shellInit = ''
              eval (/opt/homebrew/bin/brew shellenv)
              set PATH /Users/mukul/.nix-profile/bin /run/current-system/sw/bin  /nix/var/nix/profiles/default/bin /opt/homebrew/anaconda3/bin $PATH
              eval (fnm completions)
              eval (fnm env)
              set -g HOMEBREW_NO_ANALYTICS 1
              
              # >>> conda initialize >>>
              # !! Contents within this block are managed by 'conda init' !!
              if test -f /opt/homebrew/anaconda3/bin/conda
                  eval /opt/homebrew/anaconda3/bin/conda "shell.fish" "hook" $argv | source
              end
              # <<< conda initialize <<<
          '';
        };
}

