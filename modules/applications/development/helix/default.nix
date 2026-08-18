{
  inputs,
  ...
}:
{
  flake-file.inputs.nhx = {
    url = "github:Ra77a3l3-jar/nhx";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.dev = {
    imports = [ inputs.nhx.homeManagerModules.nhx ];

    programs.nhx.enable = true;
  };
}
