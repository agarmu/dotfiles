_: {
  flake.modules.nixos.base = _: {
    services.fstrim.enable = true;
  };
}
