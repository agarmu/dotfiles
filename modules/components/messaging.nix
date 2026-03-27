_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:

    {
      home.packages = with pkgs; lib.mkIf (lib.meta.availableOn stdenv.hostPlatform slack) [ slack ];
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ vesktop ];
    };
  flake.modules.darwin.gui = _: {
    homebrew.casks = [ "vesktop" ];
  };
}
