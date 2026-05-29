{ ... }:
{
  flake.modules.nixos.base =
    { ... }:
    {
      services.resolved.enable = true;
    };
}
