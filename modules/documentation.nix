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
}
