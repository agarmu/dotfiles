{
  inputs,
  ...
}:
{
  flake.modules.nixos.wheat = {
    imports = with inputs.self.modules.nixos; [
      base
      ./_hardware-configuration.nix
    ];
    system.stateVersion = "26.05";
    networking.hostName = "wheat";
  };
}
