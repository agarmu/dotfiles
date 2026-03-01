{
  inputs,
  ...
}:
{
  flake-file.inputs.wheat-firmware = {
    url = "git+ssh://git@github.com/agarmu/asahi-firmware.git";
    flake = false;
  };
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
    hardware.asahi.peripheralFirmwareDirectory = "${inputs.wheat-firmware}";
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
