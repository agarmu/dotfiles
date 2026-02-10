{ inputs, ... }:
{

  flake.modules.nixos.wheat = {
    # TODO: figure out how to fix
    # ref: https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration

    # Enable sound.

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
    programs.firefox.enable = true;
    programs.zsh = {
      enable = true;
    };

    programs.niri.enable = true;
    services.seatd.enable = true;

  };
}
