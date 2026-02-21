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
    { pkgs, config, ... }:
    {
      home.sessionVariables = {
        GDBHISTFILE = "${config.xdg.dataHome}/gdb/history";
      };
      home.packages = with pkgs; [
        gdb
        valgrind
        strace
        ltrace
        perf
        bpftrace
        flamegraph
      ];
      xdg.configFile."gdb/gdbinit" = {
        enable = true;
        source = "${inputs.gdb-dashboard}/.gdbinit";
      };
    };
}
