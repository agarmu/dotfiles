# User configuration
{ pkgs, mainUser, ... }:
{
  flake.modules.nixos.users = {
    users.users."${mainUser}" = {
      shell = pkgs.zsh;
      isNormalUser = true;
      # TODO: move groups to good places
      extraGroups = [
        "wheel"
        "seat"
        "video"
        "input"
      ];
    };
  };
}
