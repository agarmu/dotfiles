{ inputs, ... }:
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

  flake.modules.homeManager.gui = _: {
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
      };
    };
  };
}
