{
  inputs,
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
  flake.modules.darwin.homebrew =
    let
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    in
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];
      nix-homebrew = {
        inherit taps;
        enable = true;
        user = "mukul";
        mutableTaps = false;
      };
      homebrew = {
        enable = true;
        taps = builtins.attrNames taps;
        onActivation = {
          autoUpdate = false;
          cleanup = "zap";
        };
      };
      # analytics !
      environment.variables = {
        HOMEBREW_NO_ANALYTICS = "1";
      };
    };
}
