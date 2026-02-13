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
      bluetooth
      mobile
      office
      printing
      home-manager
      ./_hardware-configuration.nix
    ];
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;
    system.stateVersion = "26.05";
    networking.hostName = "wheat";
    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
        dev
        nixosDev
        gui
        nixosGui
        mobile
        image
      ];
      home.stateVersion = "26.05";
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "wheat";
}
