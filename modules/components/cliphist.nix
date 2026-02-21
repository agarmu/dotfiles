_: {
  flake.modules.homeManager.nixosGui = _: {
    services.cliphist.enable = true;
  };
}
