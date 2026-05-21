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
      home.packages = [
        inputs.voxtype.packages."${system}".osd-native
      ];
      programs.voxtype = {
        enable = true;
        package = inputs.voxtype.packages."${system}".vulkan;
        service.enable = true;
        model.name = "base.en";
      };
    };
}
