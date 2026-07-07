{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      # extra manpages for linux
      environment.systemPackages = [
        pkgs.man-pages
      ];
      documentation = {
        enable = true;
        man = {
          enable = true;
          cache = {
            enable = true;
            generateAtRuntime = true;
          };
          man-db = {
            enable = true;
          };
        };
        # no need for info
        info.enable = false;
        # document NixOS
        nixos = {
          enable = true;
          /*
            	    cannot enable this b/c of stylix. see
            	    https://github.com/nix-community/stylix/issues/98
          */
          includeAllModules = lib.mkForce false;
        };
        # development nice-to-haves
        dev.enable = true;
      };
    };
  flake.modules.darwin.base = {
    # TODO: change on fix upstream
    # workaround for github.com/nix-darwin/nix-darwin/issues/1817

    # implements the fix suggested in https://github.com/nix-darwin/nix-darwin/issues/1817#issuecomment-4887465960
    documentation.enable = lib.mkForce false;
    system.tools.darwin-uninstaller.enable = lib.mkForce false;
  };
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      programs.man = {
        enable = true;
        # this is way too slow unfortunately.
        # will enable once they do dynamically
        # like NixOS.
        # generateCaches = true;
      };
      home.packages = [ pkgs.qman ];
      home.shellAliases.q = "qman";
      xdg.configFile."qman/qman.conf".text = ''
        ; qman.conf
        ; Qman config
        ; description: Barebones configuration file for Qman

        ; Change this to a theme of your choice
        include themes/stylix.conf

        [mouse]

        ; Mouse support in some terminal emulators is incomplete and/or buggy. Set this
        ; to false if you are having mouse trouble.
        enable=             true

        [misc]

        ; If using a graphical web browser, uncomment this to suppress an annoying
        ; flicker after opening an HTTP link
        reset_after_http=   false

        ; If using a graphical email client, uncomment this to suppress an annoying
        ; flicker after opening an email link
        reset_after_email=  false

        [layout]

        ; Change this to suit your terminal window size
        lmargin=            5
        rmargin=            5'';
      xdg.configFile."qman/themes/stylix.conf".text =
        let
          inherit (config.lib.stylix) colors;
          colorKeys = (builtins.attrNames colors) |> builtins.filter (lib.hasPrefix "base");
          substInputs = colorKeys |> map (x: "@${x}@");
          substOutputs = colorKeys |> map (x: colors."${x}") |> map (x: "#${x}");
        in
        builtins.replaceStrings substInputs substOutputs (builtins.readFile ./stylix.conf);
    };
}
