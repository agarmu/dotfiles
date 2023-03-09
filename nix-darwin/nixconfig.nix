{ config, pkgs, ... }:
{
    nix.gc = {
		automatic = true;
		interval = { Hour = 24; Minute = 0; };
	};

	# Use a custom configuration.nix location.
	# $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
	# environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;
}