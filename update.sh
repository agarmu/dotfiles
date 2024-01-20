#!/bin/bash

# check for input
if [[ $# -ne 1 ]]; then
	echo "Must supply one argument (name of flake to update)"
	exit 1
fi

nix flake lock --update-input $1


