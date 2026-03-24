{ lib, inputs, ... }:
{
  /*
    Do NOT change package = pkgs.niri-unstable to pkgs.niri
    so long as the latest Niri update is (25.11) --- this is because
    the system we are using relies on fixes post-25.11 to work
    properly.

    TODO: When niri cuts a new release (> 25.11), then:
      (a) use the package from stable nixpkgs instead of the flake-provided one.
      (b) stop depending on this flake.
  */
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixpkgs-stable.follows = "nixpkgs";
  };
  flake.modules.nixos.gui =
    { pkgs, config, ... }:
    let
      # Use /run/current-system path so greetd survives nixos-rebuild
      # without getting a stale store path
      niri-bin = "/run/current-system/sw/bin/niri";

      home-config = config.home-manager.users.mukul;
      kitty-config = toString home-config.xdg.configFile."kitty/kitty.conf".source;

      greeter-swww = pkgs.writeShellScript "greeter-swww" ''
        export XDG_CACHE_HOME=/tmp/greeter-cache
        ${pkgs.swww}/bin/swww-daemon &
        sleep 0.5
        ${lib.getExe pkgs.swww} img /etc/greeter-wallpaper --transition-type none
      '';

      niri-session-bin = "/run/current-system/sw/bin/niri-session";

      greeter-session-init = pkgs.writeShellScript "greeter-session-init" ''
        # Stop any lingering niri session
        ${pkgs.systemd}/bin/systemctl --user is-active niri.service && ${pkgs.systemd}/bin/systemctl --user stop niri.service
        # Start fresh niri-session
        ${niri-session-bin}
      '';

      greeter-cmd = pkgs.writeShellScript "greeter-cmd" ''
        quote=$(${lib.getExe pkgs.fortune} -s)
        ${lib.getExe pkgs.tuigreet} --asterisks --remember --time --greeting "$quote" --cmd ${greeter-session-init}
        # Quit the greeter niri so greetd doesn't hang
        ${niri-bin} msg action quit --skip-confirmation
      '';

      greeter-niri-config-raw = pkgs.writeText "greeter-niri-config.kdl" ''
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

      greeter-niri-config =
        pkgs.runCommand "greeter-niri-config-validated.kdl"
          {
            nativeBuildInputs = [ pkgs.niri-unstable ];
          }
          ''
            niri validate -c ${greeter-niri-config-raw}
            cp ${greeter-niri-config-raw} $out
          '';
    in
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];
      environment.systemPackages = with pkgs; [
        kbd
        wl-clipboard
        xwayland
        brightnessctl
        grim
        satty
      ];

      # greetd with niri-based greeter
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${niri-bin} --config ${greeter-niri-config} -- /usr/bin/env XDG_CACHE_HOME=/tmp/greeter-cache ${lib.getExe pkgs.kitty} --config ${kitty-config} -e ${greeter-cmd}";
          user = "greeter";
        };
      };

      security.pam.services.greetd.enableGnomeKeyring = true;

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
