_: {
  flake.modules.nixos.base = _: {
    programs.mtr.enable = true;
  };
}
