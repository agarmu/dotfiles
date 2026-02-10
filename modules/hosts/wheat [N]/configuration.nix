{
  inputs,
  ...
}:
{
  flake.modules.nixos.wheat = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      systemd-boot
      bluetooth
      ./_hardware-configuration.nix
    ];
  };
}
