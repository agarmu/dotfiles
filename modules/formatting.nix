{ inputs, ... }:
{
  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-file.inputs.git-hooks-nix = {
    url = "github:cachix/git-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    let
      pre-commit-check = inputs.git-hooks-nix.lib.${system}.run {
        src = inputs.self;
        package = pkgs.prek;
        hooks = {
          treefmt = {
            enable = true;
            packageOverrides.treefmt = config.treefmt.build.wrapper;
          };
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    in
    {
      treefmt = {
        programs.nixfmt.enable = true;
        programs.kdlfmt.enable = true;
      };
      checks = { inherit pre-commit-check; };
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt
          deadnix
          statix
          prek
          nixfmt-tree
        ];
        inherit (pre-commit-check) shellHook;
        buildInputs = pre-commit-check.enabledPackages;
      };
    };
}
