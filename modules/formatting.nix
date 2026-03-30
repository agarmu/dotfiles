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
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    let
      statixPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.statix.overlays.default ];
      };
    in
    {
      treefmt = {
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;
      };
      devShells.default = pkgs.mkShell {
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };

      pre-commit.settings.hooks = {
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt;
        };
        statix = {
          enable = true;
          package = statixPkgs.statix;
        };
        deadnix.enable = true;
      };
    };
}
