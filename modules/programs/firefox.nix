{ ... }:
{
  flake.modules.nixos.gui = {
    programs.firefox.enable = true;
  };
}
