_: {
  flake.modules.homeManager.nixosGui = _: {
    services.remmina.enable = true;
  };
}
