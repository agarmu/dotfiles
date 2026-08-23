{ lib, ... }:
{
  flake.modules.homeManager.ai =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.omp;
      yamlFormat = pkgs.formats.yaml { };
    in
    {
      options.programs.omp = {
        enable = lib.mkEnableOption "oh-my-pi";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.omp;
          defaultText = lib.literalExpression "pkgs.omp";
          description = "The oh-my-pi package to install.";
        };

        settings = lib.mkOption {
          inherit (yamlFormat) type;
          default = { };
          description = ''
            Configuration written to oh-my-pi's global config.yml.

            See https://github.com/can1357/oh-my-pi/blob/main/docs/settings.md
            for the available settings.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ cfg.package ];
        home.file.".omp/agent/config.yml".source = yamlFormat.generate "omp-config.yml" cfg.settings;
      };
    };
}
