{ config, pkgs, ... }:
{
	programs.zsh = {
		enable = true;
		enableAutosuggestions = true;
		enableCompletion = true;
		enableSyntaxHighlighting = true;
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
			eval "$(/usr/libexec/path_helper)"
			eval "$(/opt/homebrew/bin/brew shellenv)"
			export PATH="/Users/mukul/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:"$PATH
		'';
	};
}

