{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.htop.enable = true;
      programs.btop.enable = true;
      home.shellAliases.top = "${pkgs.btop}/bin/btop";
    };
}
