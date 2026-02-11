{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        (
          [
            lldb
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux [
            gdb
            valgrind
          ])
        );
    };
}
