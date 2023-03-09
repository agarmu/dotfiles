{ config, pkgs, ... }:
{
	programs.gh = {
		enable = true;
		enableGitCredentialHelper = true;
		extensions = with pkgs; [
			gh-eco
			gh-dash
		];
	};
}

