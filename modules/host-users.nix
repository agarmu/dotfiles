_: let
  hostname = "Mukul-MBP";
  username = "mukul";
in {
  networking = {
    hostName = hostname;
    computerName = hostname;
    localHostName = hostname;
  };
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };

  nix.settings.trusted-users = [username];
}
