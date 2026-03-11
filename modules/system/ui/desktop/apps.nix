{ inputs, ... }:
{
  flake-file.inputs.walker = {
    url = "github:abenz1267/walker";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      imports = [
        inputs.walker.homeManagerModules.default
      ];

      services.cliphist.enable = true;
      programs.hyprlock.enable = true;

      programs.walker = {
        enable = true;
        runAsService = true;
        package = pkgs.walker;
        config = {
          close_when_open = true;
          force_keyboard_focus = true;
          search = {
            placeholder = "Search...";
          };
          list = {
            max_height = 300;
          };
        };
        themes.catppuccin = {
          style = ''
            * {
              font-family: "Source Sans 3", sans-serif;
              font-size: 16px;
            }

            #window {
              background: transparent;
            }

            #box {
              background: rgba(36, 39, 58, 0.9);
              border-radius: 12px;
              padding: 12px;
              border: 2px solid #494d64;
            }

            #search {
              background: #363a4f;
              color: #cad3f5;
              border-radius: 8px;
              padding: 8px 12px;
              margin-bottom: 8px;
              border: 1px solid #494d64;
            }

            #search:focus {
              border-color: #8aadf4;
            }

            #list row {
              padding: 6px 8px;
              border-radius: 8px;
              color: #cad3f5;
            }

            #list row:selected {
              background: #494d64;
              color: #cad3f5;
            }

            #list row:hover {
              background: rgba(73, 77, 100, 0.5);
            }

            #icon {
              margin-right: 8px;
            }

            #text {
              color: #cad3f5;
            }

            #sub {
              color: #6e738d;
            }
          '';
        };
      };

      services.swaync = {
        enable = true;
        settings = {
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          control-center-layer = "overlay";
          cssPriority = "user";

          timeout = 8;
          timeout-low = 4;
          timeout-critical = 0;

          notification-window-width = 400;
          control-center-width = 450;

          fit-to-screen = true;
          relative-timestamps = true;
          notification-icon-size = 48;
          notification-body-image-height = 100;
          notification-body-image-width = 200;

          widgets = [
            "title"
            "dnd"
            "mpris"
            "notifications"
          ];
          widget-config = {
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "Clear";
            };
            dnd = {
              text = "Do Not Disturb";
            };
            mpris = {
              image-size = 80;
              image-radius = 8;
            };
          };

          notification-visibility = { };
        };
        style = ''
          * {
            font-family: "Source Sans 3", sans-serif;
            font-size: 14px;
          }

          .control-center {
            background: rgba(36, 39, 58, 0.95);
            border-radius: 12px;
            border: 2px solid #494d64;
            margin: 8px;
            padding: 8px;
          }

          .notification-row {
            outline: none;
            margin: 4px 0;
          }

          .notification {
            background: #363a4f;
            border-radius: 10px;
            border: 1px solid #494d64;
            padding: 0;
            margin: 4px 8px;
          }

          .notification-default-action {
            padding: 8px;
            border-radius: 10px;
          }

          .notification-default-action:hover {
            background: rgba(73, 77, 100, 0.4);
          }

          .notification-content {
            padding: 4px;
          }

          .summary {
            color: #cad3f5;
            font-weight: bold;
          }

          .body {
            color: #a5adcb;
          }

          .time {
            color: #6e738d;
            font-size: 12px;
          }

          .close-button {
            background: #ed8796;
            border-radius: 50%;
            color: #24273a;
            min-width: 20px;
            min-height: 20px;
            padding: 2px;
          }

          .close-button:hover {
            background: #ee99a0;
          }

          .control-center-list {
            background: transparent;
          }

          .floating-notifications {
            background: transparent;
          }

          .widget-title {
            color: #cad3f5;
            font-size: 16px;
            font-weight: bold;
            padding: 8px;
          }

          .widget-title button {
            background: #363a4f;
            color: #cad3f5;
            border-radius: 8px;
            padding: 4px 12px;
            border: 1px solid #494d64;
          }

          .widget-title button:hover {
            background: #494d64;
          }

          .widget-dnd {
            color: #cad3f5;
            padding: 4px 8px;
          }

          .widget-dnd > switch {
            background: #363a4f;
            border-radius: 12px;
            border: 1px solid #494d64;
          }

          .widget-dnd > switch:checked {
            background: #8aadf4;
          }

          .widget-dnd > switch slider {
            background: #cad3f5;
            border-radius: 50%;
          }

          .widget-mpris {
            background: #363a4f;
            border-radius: 10px;
            padding: 8px;
            margin: 4px 8px;
            border: 1px solid #494d64;
          }

          .widget-mpris-title {
            color: #cad3f5;
            font-weight: bold;
          }

          .widget-mpris-subtitle {
            color: #a5adcb;
          }
        '';
      };
    };
}
