{
  flake.modules.nixos.base.nixpkgs.overlays = [
    (final: _prev: import ../../../pkgs final)
  ];
}
