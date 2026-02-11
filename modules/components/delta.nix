_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.delta = {
        enable = true;
        home.shellAliases.diff = "${pkgs.btop}/bin/delta";
      };
    };
}
