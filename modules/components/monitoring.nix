_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.htop.enable = true;
      programs.btop.enable = true;
      programs.bottom.enable = true;
      home.shellAliases.top = "${pkgs.btop}/bin/btop";
      home.packages = with pkgs; [
        duf # better df
        dust # better du
        procs # better ps
      ];
    };
}
