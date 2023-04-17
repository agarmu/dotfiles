{ config, pkgs, ... }:
let draculatheme = builtins.fetchurl {
	url = "https://raw.githubusercontent.com/dracula/sublime/c5de15a0ad654a2c7d8f086ae67c2c77fda07c5f/Dracula.tmTheme";
	sha256 = "0nlapygw0jwv1gvg9mkb47n3v6hq1i86y587h889sxd2ymygwrv7";
}; in
{
	programs.bat = {
		enable = true;
		extraPackages = with pkgs.bat-extras; [ batgrep batman batpipe batwatch batdiff prettybat ];
		config = {
			theme = "dracula";
		};
		themes = {
			dracula = builtins.readFile (draculatheme);
		};
	};
}

