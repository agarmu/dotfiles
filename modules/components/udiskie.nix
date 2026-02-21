_: {
  flake.modules.nixos.base = _: {
    services.udisks2.enable = true;
  };
  flake.modules.homeManager.nixosGui = _: {
    services.udiskie.enable = true;
  };
}
