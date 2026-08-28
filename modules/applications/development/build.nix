{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          cmake
          just
          make
        ];
      home.packages = with pkgs; [
        cmake # Very bad but must use
        gnumake # Often used badly
        just # More sane makefile
        meson # build tool
      ];
    };
}
