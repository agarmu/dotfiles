{ inputs, ... }:
let
  privateModule = t: inputs.dots-private.modules."${t}".default;
in
{
  flake-file.inputs.dots-private = {
    url = "git+ssh://git@github.com/agarmu/dots-private.git";
    inputs.flake-parts.follows = "flake-parts";
  };
  flake.modules.nixos.base.imports = [
    (privateModule "nixos")
  ];
  flake.modules.homeManager.gui.imports = [
    (privateModule "homeManager")
  ];
}
