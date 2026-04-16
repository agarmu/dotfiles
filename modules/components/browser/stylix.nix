_: {
  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
      stylix.targets.firefox = {
        enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = [ "default" ];
        colors.override = config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/tomorrow.yaml";
      };
    };
}
