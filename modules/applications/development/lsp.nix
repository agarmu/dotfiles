{
  flake.modules.homeManager.dev = {
    programs.zed-editor.extensions = [
      "scala"
      "haskell"
      "python"
      "ocaml"
      "typescript"
      "astro"
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
      ts_ls = {
        enable = true;
        package = null;
      };
      astro = {
        enable = true;
        package = null;
      };
    };
  };
}
