# Nix Dotfiles

My [**Nix**](https://nixos.org/) dotfiles using
[**nix-darwin**](https://github.com/LnL7/nix-darwin)
and [**home-manager**](https://github.com/nix-community/home-manager).

My dotfiles are inspired by those of:

- [Calum Macrae (cmacrae)](https://github.com/cmacrae/config)
- [Mihai Fufezan (fufexan)](https://github.com/fufexan/dotfiles)
- [Felix Breuer (breuerfelix)](https://github.com/breuerfelix/dotfiles)

## License

This repository is licensed under the [*MIT License*](./LICENSE).

## Organization

This repository is generally organized into the following:

- [`./home`](./home): Files/configurations related to home-manager. In theory,
  these should be mostly cross-platform.

- [`./modules`](./modules): Files/configurations related to system management.
  Very platform-specific.


## Goals

Some of my goals for the future are:

- Make configuration more platform-independent
- Configure Optiplex Server computer using NixOS and add to configuration.

## Module Reference

This flake defines custom modules under `flake.modules.*` that can be imported into system and home-manager configurations. Below is a complete reference of all available modules:

### Machine Configurations

| Module | Platform |
|--------|----------|
| `nixos.wheat` | NixOS |
| `darwin.sorghum` | Darwin |

### System Modules

| Module | Platform |
|--------|----------|
| `nixos.base` | NixOS |
| `darwin.base` | Darwin |
| `nixos.gui` / `darwin.gui` | Both |
| `nixos.asahi` | NixOS |
| `nixos.home-manager` | NixOS |
| `darwin.home-manager` | Darwin |
| `nixos.sshServer` / `darwin.sshServer` | Both |
| `darwin.homebrew` | Darwin |
| `nixos.printing` | NixOS |
| `nixos.bluetooth` | NixOS |
| `nixos.office` | NixOS |

### Home Manager Modules

| Module |
|--------|
| `homeManager.base` |
| `homeManager.dev` |
| `homeManager.gui` |
