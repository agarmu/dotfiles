{
  inputs,
  ...
}:
{
  flake.modules.nixos.host-wheat = {
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
}
