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
          ++ (lib.mkIf (pkgs.stdenv.isLinux) [
            gdb
            valgrind
          ])
        );
    };
}
