{ inputs, lib, ... }:
{
  flake-file.inputs = {
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      stylix.targets.firefox = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
      };
      programs.firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/user.js"}
          '';
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
          extensions.force = true;
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            bitwarden
            zotero-connector
          ];
        };
      };
    };
}
