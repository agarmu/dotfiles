_: {
  flake.modules.homeManager.base = _: {
    services.syncthing.enable = true;
  };
}
