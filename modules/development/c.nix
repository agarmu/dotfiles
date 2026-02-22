_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.lsp.servers.clangd.enable = true;
      home.packages = with pkgs; [
        gcc
        llvm
        clang-analyzer
        lldb
      ];
    };
}
