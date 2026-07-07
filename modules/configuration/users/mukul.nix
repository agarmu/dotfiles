_:
let
  userName = "mukul";
  sharedConfig =
    { pkgs, ... }:
    let
      homeDirName = if pkgs.stdenv.hostPlatform.isDarwin then "Users" else "home";
    in
    {
      users.users.${userName} = {
        home = "/${homeDirName}/${userName}";
        shell = pkgs.zsh;
      };
      # of course, enable that shell at the system level
      programs.zsh.enable = true;
    };
in
{
  flake.modules.nixos.base = {
    imports = [ sharedConfig ];
    users.users.${userName} = {
      isNormalUser = true;
      # TODO: separate these out
      extraGroups = [
        "wheel"
        "audio"
        "seat"
        "video"
        "input"
        "networkmanager"
      ];
    };
  };

  flake.modules.darwin.base = {
    imports = [ sharedConfig ];
    system.primaryUser = userName;
  };
}
