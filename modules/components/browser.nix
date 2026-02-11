{inputs, ...}: {
  flake-file.inputs.zen-browser = {
    url = "github:youwen5/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;
    };

    flake.modules.homeManager.gui =
      { pkgs, ... }:
      {
        # use zen
        home.packages = [
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
}
