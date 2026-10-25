{
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      # Keep FastAPI and application dependencies in each project's .venv.
      home.packages = with pkgs; [
        python3
        uv
        basedpyright
        ruff
      ];
      programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft.python = [ "ruff_format" ];
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          haskell
          ocaml
          python
          scala
        ];
      programs.zed-editor.extensions = [
        "scala"
        "haskell"
        "python"
        "ocaml"
      ];
      programs.nixvim.plugins.lsp.servers = {
        metals = {
          enable = true;
          package = null;
        };
        hls = {
          enable = true;
          package = null;
          installGhc = false;
        };
        basedpyright = {
          enable = true;
          package = null;
        };
        ocamllsp = {
          enable = true;
          package = null;
        };
        # Use the project's Ruff configuration when present.
        ruff = {
          enable = true;
          packageFallback = true;
        };
      };
    };
}
