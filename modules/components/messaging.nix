_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      slack =
        if pkgs.stdenv.hostPlatform.isAarch64 && pkgs.stdenv.isLinux then pkgs.slacky else pkgs.slack;
    in
    {
      home.packages = [ slack ];
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
