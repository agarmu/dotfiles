{ inputs, ... }:
{
  flake-file.inputs.voxtype = {
    url = "github:/peteonrails/voxtype";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      imports = [ inputs.voxtype.homeManagerModules.default ];
      # home.packages = [
      #   inputs.voxtype.packages."${system}".osd-gtk4
      # ];
      programs.voxtype = {
        enable = true;
        package = pkgs.voxtype-vulkan;
        service.enable = true;
        model.name = "base.en";
      };
    };
}
