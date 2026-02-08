{ inputs, ... }:
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
}
