{ ... }:
{
  flake.modules.nixos.base =
    { ... }:
    {
      networking.nameservers = [
        "1.1.1.1"
      ];
      services.resolved.enable = true;
    };
}
