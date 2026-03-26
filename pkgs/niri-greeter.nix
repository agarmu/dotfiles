{
  lib,
  writeShellScript,
  fortune,
  tuigreet,
  kitty,
  cage,
  mukul,
}:
{ kittyConfig }:
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

  cage-cmd = writeShellScript "cage-cmd" ''
    echo "cage-cmd: starting auto-scale" >&2
    ${lib.getExe mukul.auto-scale} || echo "cage-cmd: auto-scale failed with $?" >&2
    echo "cage-cmd: launching kitty" >&2
    exec ${lib.getExe kitty} --config ${kittyConfig} -e ${greeter-cmd}
  '';
in
{
  command = "env XDG_CACHE_HOME=/tmp/greeter-cache ${lib.getExe cage} -s -- ${cage-cmd}";
}
