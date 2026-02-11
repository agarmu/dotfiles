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
  };
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;
    };

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      programs.zen-browser = {
        enable = true;
        darwinDefaultsId = lib.mkDefault "org.browser-zen.plist";
        # profiles.default.extensions.packages =
        #   with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        #     ublock-origin dearrow bitwarden /* bypass-paywalls-clean */ zotero-connector
        #   ];
      };
    };
}
