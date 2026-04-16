{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      validated-config =
        pkgs.runCommand "niri-config-validated"
          {
            nativeBuildInputs = [ pkgs.niri-unstable ];
          }
          ''
            niri validate -c ${./config.kdl}
            cp ${./config.kdl} $out
          '';
    in
    {
      home.packages = [ pkgs.xwayland-satellite-unstable ];
      home.file.".config/niri/config.kdl".source = validated-config;
    };
}
