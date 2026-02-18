_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
        llvm
        clang-analyzer
        lldb
      ];
    };
}
