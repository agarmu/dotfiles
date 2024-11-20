{...} : let
  hostname = "Mukul's MacBook Pro";
  username = "mukul";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  networking.localHostName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };

  nix.settings.trusted-users = [username];
}
