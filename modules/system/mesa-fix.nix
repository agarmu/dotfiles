{ lib, inputs, ... }:
{
  # Pin graphics driver due to bug:
  #  - see: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/15288

  # TODO: remove this when mesa is fixed upstream
  # (and packaged in nixos-unstable)
  flake-file.inputs.nixpkgs-mesa-26-0-4 = {
    url = "github:nixos/nixpkgs/0d48975cf3cf588e820cad9d5c905fdcb35a2d4b";
  };
  flake.modules.nixos.host-wheat =
    { pkgs, ... }:
    let
      mesaPkgs = import inputs.nixpkgs-mesa-26-0-4 {
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    in
    {
      hardware.graphics.package = lib.mkForce mesaPkgs.mesa;
    };
}
