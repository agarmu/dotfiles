{ pkgs, ... }:
{
  flake.modules.nixos.base = {
    environment.systemPackages = with pkgs; [ zed-editor ];
  };
}
