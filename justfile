alias b := build
alias u := update
alias optimize := optimise

build:
	nix build .#darwinConfigurations.macbook-pro.system \
		--extra-experimental-features 'nix-command flakes' \
		-j 8

darwin-debug:
	nix build .#darwinConfigurations.macbook-pro.system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes' \
		-j 8

update INPUT:
	nix flake update {{INPUT}}


update-all:
	nix flake update

diff:
	nvd diff /run/current-system result

switch:
	./result/sw/bin/darwin-rebuild switch -j 16 --flake .#macbook-pro

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug


collect-garbage: gc 
    nix-collect-garbage -d
    sudo nix-collect-garbage -d

fmt:
	# format the nix files in this repo
	nix fmt

meta:
	nix flake metadata

clean:
	rm -rf result

optimise:
	nix-store --optimise --verbose


brew-cleanup:
	brew cleanup --prune=all -s && rm -rv "$(brew --cache)"


maintenance: optimise collect-garbage brew-cleanup clean
