_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      services.locate = {
        enable = true;
        package = pkgs.plocate;
      };
    };
}
