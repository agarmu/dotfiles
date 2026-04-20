{
  flake.modules.homeManager.nixosGui =
    { pkgs, config, ... }:
    {
      programs.foliate = {
        enable = true;
      };
      stylix.targets.foliate.colors.override =
        config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/everforest-light-hard.yaml";
      programs.calibre = {
        enable = true;
        package = pkgs.calibre-no-speech;
      };
    };
}
