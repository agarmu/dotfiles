{
  flake.modules.homeManager.dev = {
    programs.nixvim.plugins.lsp.servers = {
      gleam = {
        enable = true;
        package = null;
      };
      elixirls = {
        enable = true;
        package = null;
      };
    };
  };
}
