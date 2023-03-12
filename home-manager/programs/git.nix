{ config, pkgs, ... }:
{
	programs.git = {
		enable = true; 
		difftastic.enable = true;
		lfs = {
			enable = true;
			skipSmudge = false;
		};
		signing = {
			key = null;
			signByDefault = true;
		};
		userEmail = "agarmukul23@gmail.com";
		userName = "mukul";
	};
}