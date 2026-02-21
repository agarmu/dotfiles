_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };
      users.users.mukul.extraGroups = [ "wireshark" ];
    };
}
