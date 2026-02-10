{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        (
          [
            gcc
            llvm
            clang-analyzer
            lldb
          ]
          ++ (lib.mkIf (pkgs.stdenv.isLinux) [
            gdb
            valgrind
          ])
        );
    };
}
