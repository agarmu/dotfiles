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
      home-manager
      ./_hardware-configuration.nix
    ];
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

    virtualisation.vmVariant = {
      users.users.mukul.initialPassword = "wheat";
      security.sudo.wheelNeedsPassword = false;
      virtualisation = {
        memorySize = 4096;
        cores = 4;
        graphics = true;
        diskSize = 4096;
        resolution = {
          x = 3024;
          y = 1964;
        };
        qemu.options = [
          "-device virtio-gpu-gl"
          "-display gtk,gl=on"
        ];
      };
    };
  };
}
