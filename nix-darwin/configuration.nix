{ config, pkgs, ... }:
let services = map (n: "${./services}/${n}") (builtins.attrNames (builtins.readDir ./services));
	programs = map (n: "${./programs}/${n}") (builtins.attrNames (builtins.readDir ./programs));
in
{
	imports = [
	# System Configuration
	./fonts.nix ./networking.nix ./nixconfig.nix ./packages.nix ./security.nix ./shells.nix
	./homebrew.nix
	] ++ services ++ programs;
	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog
	system.stateVersion = 4;
	environment.shellInit = ''eval "$(/usr/libexec/path_helper)"
eval "$(/opt/homebrew/bin/brew shellenv)"'';
}
