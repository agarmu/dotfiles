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
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nur.url = github:nix-community/NUR;
    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = github:lnl7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = github:helix-editor/helix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    datamine-scraper = {
      url = github:agarmu/datamine-scraper;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst-lsp = {
      url = github:nvarner/typst-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bat-catppuccin-plug = {
      url = github:catppuccin/bat;
      flake = false;
    };
    bat-typst-syntax = {
      url = github:hyrious/typst-syntax-highlight;
      flake = false;
    };
    vim-catppuccin-plug = {
      url = github:catppuccin/nvim;
      flake = false;
    };
    vim-typst-plug = {
      url = github:kaarmu/typst.vim;
      flake = false;
    };
    vim-typst-preview-plug = {
      url = github:chomosuke/typst-preview.nvim;
      flake = false;
    };
    vim-tree-plug = {
      url = github:nvim-tree/nvim-tree.lua;
      flake = false;
    };
    vim-omnisharp-plug = {
      url = github:OmniSharp/omnisharp-vim;
      flake = false;
    };
    alacritty-themes = {
      url = github:alacritty/alacritty-theme;
      flake = false;
    };
    ruby-build = {
      url = github:rbenv/ruby-build;
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
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
        system = system;
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/applications.nix
          ./modules/programs.nix
          ./modules/host-users.nix
          ./modules/services.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.mukul = import ./home;
          }
          {
            nix.nixPath = with inputs; [{inherit darwin;}];
            nixpkgs.overlays = with inputs; [
              nur.overlay
            ];
          }
        ];
      };
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
