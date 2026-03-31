_: {
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };
}
