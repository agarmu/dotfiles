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

  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
    stylix.targets.firefox = {
      enable = true;
      firefoxGnomeTheme.enable = true;
      profileNames = [ "default" ];
      colors.override =
        (config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml");
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
