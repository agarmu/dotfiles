{
  flake.modules.homeManager.gui = { pkgs, ... }: {
    programs.foliate = {
      enable = pkgs.stdenv.isLinux;
    };
    home.packages = [ pkgs.thorium-reader ];
    programs.calibre = {
      enable = true;
      package = pkgs.calibre-no-speech;
    };
  };
}
