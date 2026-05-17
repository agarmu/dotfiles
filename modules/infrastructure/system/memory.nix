{
  flake.modules.nixos.mobile = {
    zramSwap.enable = true;
    services.earlyoom.enable = true;
  };
}
