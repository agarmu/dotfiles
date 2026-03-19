{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.comma ];
    };
}
