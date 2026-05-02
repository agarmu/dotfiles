{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    let
      config-subst = pkgs.replaceVars ./config.kdl {
        shaders = pkgs.mukul.niri-shaders;
      };

      validated-config =
        pkgs.runCommand "niri-config-validated"
          {
            nativeBuildInputs = [ pkgs.niri-unstable ];
          }
          ''
            niri validate -c ${config-subst}
            cp ${config-subst} $out
          '';
    in
    {
      home.packages = [ pkgs.xwayland-satellite-unstable ];
      home.file.".config/niri/config.kdl".source = validated-config;
    };
}
