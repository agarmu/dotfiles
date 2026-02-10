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

| Module | Platform | Description |
|--------|----------|-------------|
| `nixos.wheat` | NixOS | Complete host configuration for the "wheat" machine (includes base, gui, asahi modules) |
| `darwin.barley` | Darwin | Complete host configuration for the "barley" machine (macOS system) |

### System Modules

| Module | Platform | Description |
|--------|----------|-------------|
| `nixos.base` | NixOS | Base NixOS configuration with essential packages (git, tmux, neovim, etc.), GUI tools (alacritty, waybar, etc.), systemd-boot loader, IWD wireless networking, fonts, power management (TLP), timezone settings, user configuration, iperf3, and libinput/seatd services |
| `darwin.base` | Darwin | Base macOS configuration with essential packages (git, tmux, neovim, etc.), Determinate Nix installer, and user configuration |
| `nixos.gui` | NixOS | GUI-specific configuration enabling Firefox browser |
| `nixos.asahi` | NixOS | Apple Silicon (Asahi Linux) support with specialized boot loader configuration |
| `nixos.home-manager` | NixOS | Enables home-manager integration for NixOS with user package management |
| `darwin.home-manager` | Darwin | Enables home-manager integration for nix-darwin with user package management |
| `darwin.homebrew` | Darwin | Enables management of `homebrew` |
| `nixos.sshServer` / `darwin.sshServer` | Both | OpenSSH server configuration (NixOS: with password auth and root login; Darwin: basic setup) |
| `darwin.homebrew` | Darwin | Homebrew integration via brew-nix for managing macOS-specific applications |
| `nixos.printing` | NixOS | Printing support via CUPS with Avahi for network printer discovery |
| `nixos.bluetooth` | NixOS | Bluetooth hardware support with auto-power on boot |
| `nixos.office` | NixOS | Office-oriented configuration enabling printing services |

### Home Manager Modules

| Module | Description |
|--------|-------------|
| `homeManager.base` | Base home-manager configuration with shell setup (zsh, bash, starship prompt) |
| `homeManager.office` | Office productivity packages including PDF tools (pdfarranger) |
