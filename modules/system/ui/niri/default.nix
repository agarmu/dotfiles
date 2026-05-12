{ inputs, ... }:
{
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };

  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      imports = [ inputs.niri-nix.homeModules.default ];
      wayland.windowManager.niri = {
        enable = true;
        settings.include = [
          {
            _args = [ "${pkgs.mukul.niri-shaders}/pixelate.kdl" ];
          }
        ];
        extraConfig = builtins.readFile ./config.kdl;
      };
    };
}
