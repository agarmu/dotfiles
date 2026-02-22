{
  lib,
  inputs,
  ...
}:
{
  # we use disko... require it!
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # sops-nix for secret management
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.host-millet = {
    imports = with inputs.self.modules.nixos; [
      base
      server
      home-manager
      ./_hardware-configuration.nix
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      ./_disk-config.nix
    ];
    boot.loader.efi = {
      canTouchEfiVariables = lib.mkForce true;
      efiSysMountPoint = "/boot";
    };
    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
      ];
      home.stateVersion = "26.05";
    };
  };
}
