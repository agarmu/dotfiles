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
	sudo ./result/sw/bin/darwin-rebuild switch -j 16 --flake .#macbook-pro

history:
	nix profile history --profile /nix/var/nix/profiles/system


gc:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
    nix-store --optimise

fmt:
	# format the nix files in this repo
	nix fmt

meta:
	nix flake metadata

optimise:
	nix-store --optimise

brew-cleanup:
	brew cleanup --prune=all -s && rm -rv "$(brew --cache)"


clean: gc brew-cleanup
