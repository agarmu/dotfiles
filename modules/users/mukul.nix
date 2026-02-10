{
  self,
  lib,
  ...
}:
let
  userName = "mukul";
in
{
  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      users.users.${userName} = {
        isNormalUser = true;
        home = "home/${userName}";
        # TODO: separate these out
        extraGroups = [
          "wheel"
          "audio"
          "seat"
          "video"
        ];
        shell = pkgs.zsh;
      };

      # of course, enable that shell at the system level
      programs.zsh.enable = true;
    };

  darwin.${userName} =
    { pkgs, ... }:
    {
      users.users.${userName} = {
        home = "/Users/${userName}";
        shell = pkgs.zsh;
      };
      # of course, enable that shell at the system level
      programs.zsh.enable = true;
      system.primaryUser = userName;
    };
}
