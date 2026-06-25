{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.lsp.servers.clangd.enable = true;
      programs.zed-editor.extensions = [ "c" ];
      home.packages = with pkgs; [
        gcc
        llvm
        clang-analyzer
        lldb
      ];
    };
}
