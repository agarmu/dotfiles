_: {
  flake.modules.nixos.base = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
  flake.modules.home.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.easyeffects ];
    };
}
