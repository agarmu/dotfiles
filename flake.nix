{
  description = "Nix for macOS configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "mukul" "admin"];
    substituters = [
      "https://cache.nixos.org"
      "https://cachix.org/api/v1/cache/nix-community"
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bat-typst-syntax = {
      url = "github:hyrious/typst-syntax-highlight";
      flake = false;
    };
  };
  outputs = inputs @ {
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: {
    darwinConfigurations."macbook-pro" = let
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
        inherit system;
      };
    in
      darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/applications.nix
          ./modules/programs.nix
          ./modules/host-users.nix
          ./modules/services.nix
          ./modules/environment.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "bak";
              users.mukul = import ./home;
            };
          }
          {
            nix.nixPath = [{inherit darwin;}];
            nixpkgs.overlays = with inputs; [
              nur.overlays.default
            ];
          }
        ];
      };
    # TODO: fix with flake-utils
    formatter = {
      aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
      aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    };
  };
}
