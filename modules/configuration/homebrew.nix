{ inputs, lib, ... }: {
  flake-file.inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
  flake.modules.darwin.homebrew = { config, ... }: {
    imports = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];
    nix-homebrew = {
      enable = true;
      enableRosetta = lib.mkForce false;
      # User owning the Homebrew prefix
      user = config.system.primaryUser;
      # fully declarative taps
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
      # do _not_ trust any third-party taps
      trust = {
        formulae = [ ];
        casks = [ ];
        commands = [ ];
        taps = [ ];
      };
    };
    homebrew = {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      onActivation.cleanup = "zap";
    };
  };
}
