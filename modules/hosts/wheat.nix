{ config, ... }:
{
  flake.modules.nixos.hosts.wheat = {
    networking.hostName = "wheat";
    imports = with config.flake.modules.nixos; [
      base
      gui
      asahi
      mobile
    ];
    /*
      IMPORTANT: know what we are doing before modifying this!
      https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    */
    system.stateVersion = "25.11";
  };
}
