{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.asciinema.enable = true;
      home.packages = [ pkgs.asciinema-agg ];
    };
}
