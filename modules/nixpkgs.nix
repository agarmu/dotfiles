{ inputs, withSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          /*
            todo: add filtration...maybe via
            module.args?
          */
          allowUnfreePredicate = _package: true;
        };
      };
    };
  flake.modules.nixos.base = nixosArgs: {
    nixpkgs = {
      pkgs = withSystem "aarch64-linux" (psArgs: psArgs.pkgs);
      hostPlatform = "aarch64-linux";
    };
  };
}
