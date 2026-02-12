{ inputs, ... }:
{
  flake-file.inputs.gdb-dashboard = {
    url = "github:cyrus-and/gdb-dashboard";
    flake = false;
  };
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
      xdg.configFile."gdb/gdbinit" = {
        enable = true;
        source = "${inputs.gdb-dashboard}/.gdbinit";
      };
    };
}
