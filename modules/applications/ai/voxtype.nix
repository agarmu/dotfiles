{ inputs, ... }:
{
  flake-file.inputs.voxtype = {
    url = "github:/peteonrails/voxtype";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports = [ inputs.voxtype.homeManagerModules.default ];
      home.packages = [
        inputs.voxtype.packages."${system}".osd-gtk4
      ];
      programs.voxtype = {
        enable = true;
        package = pkgs.voxtype-vulkan;
        service.enable = true;
        model.name = "medium.en";
      };
    };
}
