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
}
