_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.delta = {
        enable = true;
      };
      catppuccin.delta.enable = true;

      home.shellAliases.diff = "${pkgs.btop}/bin/delta";
    };
}
