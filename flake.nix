{
  description = "Nix for machine configuration";
  nixConfig = {
    /*
      TODO: enable if needed.
      allow-import-from-derivation = true;
    */
    extra-experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };
  inputs = {
    # base
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # important: configuration tools
    blank.url = "github:divnix/blank";
    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.url = "github:cachix/git-hooks.nix";

    # replace nix with lix
    lix.url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";

    # components
    darwin.url = "github:nix-darwin/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    nix-index-database.url = "github:nix-community/nix-index-database";
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";

    # software...
    niri.url = "github:sodiboo/niri-flake";

    ### follows...
    # lix (from infinidoge config)
    lix-module.inputs.lix.follows = "lix";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix.inputs.flake-compat.follows = "blank";
    lix.inputs.nixpkgs.follows = "nixpkgs"; # TODO: ?
    lix.inputs.pre-commit-hooks.follows = "git-hooks"; # TODO: ?

    # basic
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "blank";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    # components
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

    # software packages
    niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      import-tree,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      _module.args.rootPath = ./.;
      _module.args.mainUser = "mukul";
      imports = [ (inputs.import-tree ./modules) ];
    };
}
