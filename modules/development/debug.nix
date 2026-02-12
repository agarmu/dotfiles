{ lib, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lldb
        (rizin.withPlugins (
          ps: with ps; [
            rz-ghidra
          ]
        ))
      ];
    };
  flake.modules.homeManager.nixosDev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gdb
        valgrind
      ];
    };
}
