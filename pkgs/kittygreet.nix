{
  lib,
  writeShellScript,
  writeShellApplication,
  fortune,
  tuigreet,
  kitty,
  cage,
  wlr-randr,
  coreutils,
  gnugrep,
}:
{
  kittyConfig,
  outputScale ? 1,
}:
let
  niri-session-bin = "/run/current-system/sw/bin/niri-session";

  greeter-cmd = writeShellScript "greeter-cmd" ''
    quote=$(${lib.getExe fortune} -s)
    exec ${lib.getExe tuigreet} \
      --asterisks \
      --remember \
      --time \
      --window-padding 2 \
      --greeting "$quote" \
      --cmd ${niri-session-bin}
  '';

  cage-cmd = writeShellApplication {
    name = "cage-cmd";
    runtimeInputs = [
      wlr-randr
      gnugrep
      coreutils
    ];
    text = ''
      output=$(wlr-randr | grep -oP '^\S+' | head -1)
      wlr-randr --output "$output" --scale ${toString outputScale}
      exec ${lib.getExe kitty} --config ${kittyConfig} -e ${greeter-cmd}
    '';
  };
in
{
  command = "env XDG_CACHE_HOME=/tmp/greeter-cache ${lib.getExe cage} -s -- ${lib.getExe cage-cmd}";
}
