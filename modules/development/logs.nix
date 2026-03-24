_: {
  flake.modules.homeManager.nixosDev =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.lnav ];
    };
}
