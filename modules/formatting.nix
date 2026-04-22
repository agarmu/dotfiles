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
      ...
    }:
    let
      pre-commit-check = inputs.git-hooks-nix.lib.${system}.run {
        src = inputs.self;
        package = pkgs.prek;
        hooks = {
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
          deadnix.enable = true;
        };
      };
    in
    {
      treefmt = {
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;
      };
      checks = { inherit pre-commit-check; };
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt
          deadnix
          prek
          nixfmt-tree
        ];
        inherit (pre-commit-check) shellHook;
        buildInputs = pre-commit-check.enabledPackages;
      };
    };
}
