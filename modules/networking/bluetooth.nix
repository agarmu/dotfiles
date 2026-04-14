_: {
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      environment.systemPackages = with pkgs; [ blueman ];
    };
  flake.modules.homeManager.bluetooth =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ bluetui ];
    };
}
