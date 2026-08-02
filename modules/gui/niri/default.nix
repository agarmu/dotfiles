_: {
  flake.modules.nixos.asahi = {
    boot.kernelParams = [ "appledrm.show_notch=1" ];
  };

  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      wayland.windowManager.niri = {
        package = pkgs.niri;
        enable = true;
        extraConfig = builtins.readFile ./config.kdl;
      };
    };
}
