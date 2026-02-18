_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gping ];
      home.shellAliases.ping = "${pkgs.gping}/bin/gping";
    };
}
