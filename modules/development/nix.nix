{ inputs, ... }:
{
  flake-file.inputs.statix = {
    url = "github:oppiliappan/statix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };
  flake.modules.nixos.dev = {
    overlays = [
      inputs.statix.overlays.default
    ];
  };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd # lsp
        deadnix # dead code detection
        statix # static analysis
        nix-tree
      ];
    };
}
