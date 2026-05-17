{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ (final: _prev: import ../../pkgs final) ];
      };
    in
    {
      packages = pkgs.lib.filterAttrs (_: v: builtins.isAttrs v && pkgs.lib.isDerivation v) pkgs.mukul;
    };
}
