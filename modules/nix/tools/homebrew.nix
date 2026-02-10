{
  inputs,
  config,
  ...
}:
{
  flake-file.inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
  flake.modules.darwin.homebrew = {
    imports = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];
    nix-homebrew = {
      enable = true;
      user = "agarmu";
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
      mutableTaps = false;
    };
    homebrew.taps = builtins.attrNames config.flake.modules.darwin.homebrew.nix-homebrew.taps;
  };
}
