{
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn-patched;
    };
  };
}
