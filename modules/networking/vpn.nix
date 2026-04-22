{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      services.mullvad-vpn = {
        enable = false;
        package = pkgs.mullvad-vpn;
      };
    };
}
