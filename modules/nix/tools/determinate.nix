{ inputs, ... }:
{
  /*
    followed instructions from:
    https://docs.determinate.systems/guides/nix-darwin/
  */
  flake-file.inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  flake.modules.darwin.base = {
    imports = [
      inputs.determinate.darwinModules.default
    ];
    nix.enable = false;
    determinateNix = {
      enable = true;
    };
  };
}
