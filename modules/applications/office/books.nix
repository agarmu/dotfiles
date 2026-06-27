{ lib, ... }: {
  flake.modules.homeManager.gui = { pkgs, ... }: {
    programs.foliate = {
      enable = pkgs.stdenv.isLinux;
    };
    home.packages = [ pkgs.thorium-reader ];
    # app linking needed b/c QtWebEngine has internal up-links.
    targets.darwin = {
      linkApps.enable = lib.mkForce true;
      copyApps.enable = lib.mkForce false;
    };
    programs.calibre = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs.mukul.calibre-bin else pkgs.calibre-no-speech;
    };
  };

}
