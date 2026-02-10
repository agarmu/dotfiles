# System-wide packages and environment
{ pkgs, ... }:
{
  flake.modules.nixos.base = {
    # basic packages to always have access to
    environment.systemPackages = with pkgs; [
      wget
      rsync
      nano
    ];

  };
}
