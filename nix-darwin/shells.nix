{ config, pkgs, ... }:
{
	environment.shells = 
		with pkgs; [
			bashInteractive
			zsh
			fish
			nushell
		];
	# Create /etc/zshrc that loads the nix-darwin environment.
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		enableFzfCompletion = true;
		enableFzfGit = true;
		enableSyntaxHighlighting = true;
	};
}