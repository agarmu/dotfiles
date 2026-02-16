{
  inputs,
  lib,
  ...
}:
{
  # Helper functions for creating system / home-manager configurations

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.niri.overlays.niri
            inputs.nur.overlays.default
          ];
          config.allowUnfree = true;
        };
        modules = [ inputs.self.modules.homeManager.${name} ];
      };
    };

  };
}
