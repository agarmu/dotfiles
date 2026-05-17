# Nix Dotfiles

My [**Nix**](https://nixos.org/) dotfiles using
and [**home-manager**](https://github.com/nix-community/home-manager).

My dotfiles are inspired by those of:

- [Calum Macrae (cmacrae)](https://github.com/cmacrae/config)
- [Mihai Fufezan (fufexan)](https://github.com/fufexan/dotfiles)
- [Felix Breuer (breuerfelix)](https://github.com/breuerfelix/dotfiles)
- [Infinidoge](https://github.com/infinidoge/universe)

## License

This repository is licensed under the [*GNU Affero General Public License*](./LICENSE).

## Organization

The `flake.nix` file is basically a layer of thin glue; inside the directory
`modules`, every `.nix` file (excluding those beginning with an underscore, or a
child of some directory with an underscore) are taken to be a `flake-parts`
module. This way, we are able to compose a (mostly) modular configuration.


## Goals

Some of my goals for the future are:

- Configure Optiplex Server computer using NixOS and add to configuration.
- Configure `aarch64-linux` build serves.
- Use `facter` to manage hardware configuration (instead of
  `nixos-generate-config`)

## Module Reference

This flake defines custom modules under `flake.modules.*` that can be imported into system and home-manager configurations. Below is a complete reference of all available modules:

### Machine Configurations

| Module | Platform |
|--------|----------|
| `nixos.wheat` | NixOS |

### System Modules

| Module | Platform |
|--------|----------|
| `nixos.base` | NixOS |
| `nixos.gui` | Both |
| `nixos.asahi` | NixOS |
| `nixos.home-manager` | NixOS |
| `nixos.sshServer`  | Both |
| `nixos.bluetooth` | NixOS |
| `nixos.office` | NixOS |

### Home Manager Modules

| Module |
|--------|
| `homeManager.base` |
| `homeManager.dev` |
| `homeManager.gui` |
