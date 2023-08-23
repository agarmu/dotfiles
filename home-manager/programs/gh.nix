{ config, pkgs, ... }:
{
	programs.gh = {
		enable = true;
                gitCredentialHelper = {
                  enable = true;
                };
		extensions = with pkgs; [
			gh-eco
			gh-dash
		];
	};
}

