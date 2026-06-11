{ lib, inputs, ... }:

{
  flake-file.inputs.niri-screen-time = {
    url = "github:probeldev/niri-screen-time";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.base = {
    nixpkgs.overlays = [
      (_: prev: {
        niri-screen-time = inputs.niri-screen-time.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:

    {
      home.packages = [ pkgs.niri-screen-time ];

      systemd.user.services.niri-screen-time = {
        Unit = {
          Description = "Track application screen time";
          PartOf = [ "niri.service" ];
          After = [ "niri.service" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.niri-screen-time} -daemon";
          Restart = "on-failure";
          RestartSec = "2s";
        };
        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };
}
