{
  lib,
  inputs,
  ...
}:
{
  # flake-parts does not provide a darwinConfigurations option
  # so we declare it manually
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      darwinConfigurations = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = { };
      };
    };
  };
}
