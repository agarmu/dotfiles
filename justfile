alias b := build
alias u := update

build:
	nix build .#darwinConfigurations.macbook-pro.system \
		--extra-experimental-features 'nix-command flakes' \
		-j 8

darwin-debug:
	nix build .#darwinConfigurations.macbook-pro.system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes' \
		-j 8

update INPUT:
	nix flake lock --update-input {{INPUT}}


update-all:
	nix flake update

diff:
	nvd diff /run/current-system result

switch:
	./result/sw/bin/darwin-rebuild switch --flake .#macbook-pro

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

meta:
	nix flake metadata

clean:  
	rm -rf result

