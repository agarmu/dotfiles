{ config, pkgs, ... }:
{
environment.systemPackages = 
	with pkgs; [
			coreutils
			exa
			ffmpeg
			htop
			jq
			mold
	  		rustup
			wget
			wget2
		];
}
