{ config, pkgs, ... }:
let username = "mukul"; homedir = "/Users/${username}";
in
{
	imports = [ <home-manager/nix-darwin> ];
	users.users.mukul = {
		name = username;
		home = homedir;
	};
	home-manager = {
		backupFileExtension = "orig";

	};
	home-manager.users.mukul = {pkgs, ... }:
	let
		programs = map (n: "${./programs}/${n}") (builtins.attrNames (builtins.readDir ./programs));
		services = map (n: "${./services}/${n}") (builtins.attrNames (builtins.readDir ./services));
	in
	{
		imports = [ ./packages.nix ] ++ programs ++ services;
		nixpkgs.config = {
			allowUnfree = true;
		};
		# Home Manager needs a bit of information about you and the
		# paths it should manage.
		home = {
			username = username;
			homeDirectory = homedir;
			shellAliases = {
				"ll" = "exa -l";
				"la" = "exa -al";
				"tree" = "exa --tree";
				"tral" = "exa --tree -al";
				".." = "cd ..";
			};
		};

		# This value determines the Home Manager release that your
		# configuration is compatible with. This helps avoid breakage
		# when a new Home Manager release introduces backwards
		# incompatible changes.
		#
		# You can update Home Manager without changing this value. See
		# the Home Manager release notes for a list of state version
		# changes in each release.
		home.stateVersion = "22.11";
	};
}
