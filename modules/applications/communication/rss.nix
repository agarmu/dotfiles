{
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.net-news-wire ];
  };
}
