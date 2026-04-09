{ inputs, ... }:
let
  privateModule = t: inputs.dots-private.modules."${t}".default;
in
{
  flake-file.inputs.dots-private = {
    url = "git+ssh://git@github.com/agarmu/dots-private.git";
    inputs.flake-parts.follows = "flake-parts";
    inputs.home-manager.follows = "home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.import-tree.follows = "import-tree";
  };
  flake.modules.homeManager.gui.imports = [
    (privateModule "homeManager")
  ];
}
