darwin:
	nix build .#darwinConfigurations.macbook-pro.system \
		--extra-experimental-features 'nix-command flakes' \
		-j 8

darwin-debug:
	nix build .#darwinConfigurations.macbook-pro.system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes' \
		-j 8
diff:
	nvd diff /run/current-system result 

switch: darwin
	./result/sw/bin/darwin-rebuild switch --flake .#macbook-pro 

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
	nix fmt

.PHONY: clean darwin darwin-debug diff update history gc fmt 
clean:  
	rm -rf result
