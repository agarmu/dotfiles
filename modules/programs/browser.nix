{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;
    };
}
