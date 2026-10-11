{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.omp ];
    };

  flake.modules.darwin.base = {
    homebrew.casks = [ "codex" ];
  };
}
