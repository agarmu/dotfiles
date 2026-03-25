{
  lib,
  writeShellScript,
  writeText,
  runCommand,
  swww,
  systemd,
  fortune,
  tuigreet,
  kitty,
  niri-unstable,
}:
{ kittyConfig }:
let
  # Use /run/current-system path so greetd survives nixos-rebuild
  # without getting a stale store path
  niri-bin = "/run/current-system/sw/bin/niri";
  niri-session-bin = "/run/current-system/sw/bin/niri-session";

  greeter-swww = writeShellScript "greeter-swww" ''
    export XDG_CACHE_HOME=/tmp/greeter-cache
    ${swww}/bin/swww-daemon &
    sleep 0.5
    ${lib.getExe swww} img /etc/greeter-wallpaper --transition-type none
  '';

  greeter-session-init = writeShellScript "greeter-session-init" ''
    # Stop any lingering niri session
    ${systemd}/bin/systemctl --user is-active niri.service && ${systemd}/bin/systemctl --user stop niri.service
    # Start fresh niri-session
    ${niri-session-bin}
  '';

  greeter-cmd = writeShellScript "greeter-cmd" ''
    quote=$(${lib.getExe fortune} -s)
    ${lib.getExe tuigreet} --asterisks --remember --time --greeting "$quote" --cmd ${greeter-session-init}
    # Quit the greeter niri so greetd doesn't hang
    ${niri-bin} msg action quit --skip-confirmation
  '';

  greeter-niri-config-raw = writeText "greeter-niri-config.kdl" ''
    hotkey-overlay {
      skip-at-startup
    }

    spawn-at-startup "${greeter-swww}"

    layout {
      background-color "transparent"
      center-focused-column "always"
      gaps 16
      struts {
        top 48
      }

      focus-ring {
        off
      }

      border {
        off
      }
    }

    window-rule {
      open-maximized true
    }

    layer-rule {
      match namespace="^swww.*$"
      place-within-backdrop true
    }

    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
      touchpad {
        tap
        dwt
        natural-scroll
        accel-speed 0.2
      }
      mouse {
        accel-profile "flat"
      }
    }
  '';

  config =
    runCommand "greeter-niri-config-validated.kdl"
      {
        nativeBuildInputs = [ niri-unstable ];
      }
      ''
        niri validate -c ${greeter-niri-config-raw}
        cp ${greeter-niri-config-raw} $out
      '';
in
{
  inherit config;
  command = "${niri-bin} --config ${config} -- /usr/bin/env XDG_CACHE_HOME=/tmp/greeter-cache ${lib.getExe kitty} --config ${kittyConfig} -e ${greeter-cmd}";
}
