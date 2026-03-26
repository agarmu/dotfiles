{ inputs, ... }:
{
  flake-file.inputs.betterfox = {
    url = "github:HeitorAugustoLN/betterfox-nix";
    inputs.flake-parts.follows = "flake-parts";
    inputs.import-tree.follows = "import-tree";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.gui = {
    imports = [ inputs.betterfox.modules.homeManager.betterfox ];
    programs.firefox.betterfox.enable = true;
    programs.firefox.betterfox.profiles.default = {
      enableAllSections = true;
    };
  };
}
