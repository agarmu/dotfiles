{
  flake.modules.nixos.asahi = {
    hardware.asahi.setupAsahiSound = true;
  };
  flake.modules.nixos.base = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.easyeffects ];
    };
}
