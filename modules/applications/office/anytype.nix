{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.anytype ];
    };
  flake.modules.darwin.homebrew.homebrew.casks = [ "anytype" ];
}
