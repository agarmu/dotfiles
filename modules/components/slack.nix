{ ... }:
{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      package =
        if pkgs.stdenv.hostPlatform.isAarch64 && pkgs.stdenv.isLinux then pkgs.slacky else pkgs.slack;
    in
    {
      home.packages = [ package ];
    };
}
