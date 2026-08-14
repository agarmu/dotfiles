{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.foliate = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
      };
      home.packages = [ pkgs.thorium-reader ];
      programs.calibre = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.calibre-bin else pkgs.calibre-no-speech;
      };
    };

}
