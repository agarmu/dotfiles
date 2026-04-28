{ lib, ... }:
{
  # TODO: remove on https://github.com/NixOS/nixpkgs/pull/513771
  # in nixos-unstable
  flake.modules.nixos.asahi = {
    boot.kernel.sysctl = {
      "vm.mmap_rnd_bits" = lib.mkForce 31;
    };
  };
}
