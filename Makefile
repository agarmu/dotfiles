darwin:
	nix build .#darwinConfigurations.rosencrantz.system \
		--extra-experimental-features 'nix-command flakes'

darwin-debug:
	nix build .#darwinConfigurations.rosencrantz.system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes'

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug

fmt:
	# format the nix files in this repo
	alejandra .

.PHONY: clean  
clean:  
	rm -rf result
