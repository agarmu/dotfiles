{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.lsp.servers.clangd = {
        enable = true;
        packageFallback = true;
        cmd = [
          "clangd"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
        ];
      };
      programs.zed-editor.extensions = [ "c" ];
      home.packages = with pkgs; [
        gcc
        llvm
        clang-analyzer
        lldb
      ];
    };
}
