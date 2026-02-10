{
  inputs,
  ...
}:
{
  flake.modules.nixos.wheat = {
    imports = with inputs.self.modules.nixos; [
      base
      gui
      asahi
      ./_hardware-configuration.nix
    ];
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;
    system.stateVersion = "26.05";
    networking.hostName = "wheat";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "wheat";
}
