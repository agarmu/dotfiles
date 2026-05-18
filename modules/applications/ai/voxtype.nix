{ inputs, ... }:
{
  flake-file.inputs.voxtype = {
    url = "github:/peteonrails/voxtype";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports = [ inputs.voxtype.homeManagerModules.default ];
      programs.voxtype = {
        enable = true;
        package = inputs.voxtype.packages."${system}".vulkan;
        service.enable = true;
        model.name = "base.en";
      };
    };
}
