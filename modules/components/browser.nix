{ inputs, lib, ... }:
{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };
  flake.modules.nixos.gui = _: {
    programs.firefox.enable = true;
  };

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      stylix.targets.zen-browser.profileNames = [ "Default Profile" ];
      programs.zen-browser = {
        enable = true;
        darwinDefaultsId = lib.mkDefault "org.browser-zen.plist";
        profiles."Default Profile" = {
          id = 0;
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
            ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
          '';
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            dearrow
            bitwarden
            zotero-connector
          ];
        };
      };
    };
}
